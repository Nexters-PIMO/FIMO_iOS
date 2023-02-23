//
//  UploadStore.swift
//  PIMOTests
//
//  Created by 김영인 on 2023/02/14.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct UploadStore: ReducerProtocol {
    struct State: Equatable {
        var uploadedImagesCount = 0
        var uploadedImage = [Image]()
        @BindingState var isShowImagePicker = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case didTapCloseButton
        case didTapUploadButton
        case selectProfileImage(Image)
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
            case .selectProfileImage(let image):
                state.uploadedImage.append(image)
                
                return .none
            default:
                return .none
            }
        }
    }
}
