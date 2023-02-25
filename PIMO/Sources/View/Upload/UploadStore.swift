//
//  UploadStore.swift
//  PIMOTests
//
//  Created by 김영인 on 2023/02/14.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI
import Vision

import ComposableArchitecture

struct UploadStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var isShowImagePicker = false
        var uploadedImages = [UploadImage]()
        
        @BindingState var isShowOCRErrorToast = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case didTapCloseButton
        case didTapUploadButton
        case didTapPublishButton
        case didTapDeleteButton(Int)
        case selectProfileImage(UploadImage)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .didTapCloseButton:
                return .none
            case .didTapUploadButton:
                state.isShowImagePicker = true
                
                return .none
            case .didTapDeleteButton(let index):
                state.uploadedImages = state.uploadedImages.filter { $0.id != index }
                var id = 0
                state.uploadedImages.forEach {
                    $0.id = id
                    id += 1
                }
                
                return .none
            case .selectProfileImage(let uploadImage):
                let extractedText = extractText(from: uploadImage, state: &state)
                let image = UploadImage(id: uploadImage.id, image: uploadImage.image, text: extractedText)
                
                if !extractedText.isEmpty {
                    state.uploadedImages.append(image)
                } else {
                    state.isShowOCRErrorToast = true
                }
                
                return .none
            case .didTapPublishButton:
                print("업로드")
                #warning("엔드포인트 (업로드)")
                return .none
            default:
                return .none
            }
        }
    }
    
    private func extractText(from image: UploadImage, state: inout State) -> String {
        guard let convertedImage = image.image.cgImage else {
            return ""
        }
        
        var extractedTexts = ""
        
        let ocrRequestHandler = VNImageRequestHandler(cgImage: convertedImage)
        let request = VNRecognizeTextRequest { request, _ in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                return
            }
            
            let recognizedTexts = observations.compactMap {
                $0.topCandidates(1).first?.string
            }
            
            extractedTexts = recognizedTexts.joined(separator: ",")
        }
        
        request.recognitionLanguages = ["kor", "eng"]
        
        do {
            try ocrRequestHandler.perform([request])
        } catch {
            state.isShowOCRErrorToast = true
        }
        
        return extractedTexts
    }
}
