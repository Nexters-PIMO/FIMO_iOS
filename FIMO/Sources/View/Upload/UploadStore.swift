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
        @BindingState var isIncompleteClose = false
        @BindingState var isShowImagePicker = false
        var uploadedPostItems = [FMPostItem]()
        
        @BindingState var isShowOCRErrorToast = false
        var toastMessage: ToastModel?
        var selectedPostItem: FMPostItem?
        var isLoading: Bool = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case didTapCloseButton
        case clearScene
        case didTapCloseButtonWithData
        case didTapUploadButton
        case didTapPublishButton
        case didTapPublishButtonDone(Result<FMPostDTO, NetworkError>)
        case didTapUploadedImage(FMPostItem)
        case didTapDeleteButton(FMPostItem)
        case selectProfileImage(UIImage)
        case fetchImageUrl(UIImage, String)
        case fetchImageUrlDone(Result<ImgurImageModel, NetworkError>, UIImage, String)
        case sendToast(ToastModel)
        case removeToast
    }

    @Dependency(\.imgurImageClient) var imgurImageClient
    @Dependency(\.postClient) var postClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .didTapCloseButton:
                state.isIncompleteClose = false
                return .init(value: .clearScene)
            case .clearScene:
                state.isShowImagePicker = false
                state.isShowOCRErrorToast = false
                state.uploadedPostItems = []
            case .didTapCloseButtonWithData:
                state.isIncompleteClose = true
                return .none
            case .didTapUploadButton:
                state.isShowImagePicker = true
                
                return .none
            case .didTapUploadedImage(let postItem):
                state.selectedPostItem = postItem
                
                return .none
            case .didTapDeleteButton(let postItem):
                state.uploadedPostItems.removeAll(where: { $0.id == postItem.id })
                
                return .none
            case .selectProfileImage(let uploadImage):
                state.isLoading = true
                let extractedText = extractText(from: uploadImage, state: &state)
                
                if !extractedText.isEmpty {
                    return .init(value: .fetchImageUrl(uploadImage, extractedText))
                } else {
                    state.isShowOCRErrorToast = true
                    
                    let message = ToastModel(
                        title: "글이 존재하지 않는 사진이에요!",
                        message: "글이 포함되어 있는 사진으로 업로드해주세요."
                    )
                    
                    return EffectTask.task {
                        return .sendToast(message)
                    }
                }
            case .fetchImageUrl(let uploadImage, let extractedText):
                return imgurImageClient
                    .uploadImage(uploadImage.jpegData(compressionQuality: 0.9) ?? Data())
                    .map {
                        Action.fetchImageUrlDone($0, uploadImage, extractedText)
                    }
            case .fetchImageUrlDone(let result, let uploadImage, let extractedText):
                switch result {
                case .success(let imageModel):
                    var postItem = FMPostItem(imageUrl: imageModel.link, content: extractedText)

                    state.uploadedPostItems.append(postItem)

                    if state.selectedPostItem == nil {
                        state.selectedPostItem = postItem
                    }
                    state.isLoading = false
                    return .none
                case .failure(let error):
                    state.isLoading = false
                    return .init(value: .sendToast(ToastModel(title: error.errorDescription ?? "")))

                }
            case .sendToast(let toastModel):
                state.toastMessage = toastModel

                return EffectTask<Action>(value: .removeToast)
                    .delay(for: .seconds(1.5), scheduler: DispatchQueue.main)
                    .eraseToEffect()
            case .removeToast:
                state.isShowOCRErrorToast = false
                return .none
            case .didTapPublishButton:
                let updatePost = FMUpdatedPost(
                    items: state.uploadedPostItems.map {
                        FMUpdatedPostItem(imageUrl: $0.imageUrl, content: $0.content)
                    }
                )

                return postClient.uploadPost(updatePost).map {
                    Action.didTapPublishButtonDone($0)
                }
            case .didTapPublishButtonDone(let result):
                switch result {
                case .success:
                    return .init(value: .clearScene)
                case .failure(let error):
                    return .init(value: .sendToast(ToastModel(title: error.errorDescription ?? "")))
                }
            default:
                return .none
            }
            return .none
        }
    }
    
    private func extractText(from image: UIImage, state: inout State) -> String {
        guard let convertedImage = image.cgImage else {
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
