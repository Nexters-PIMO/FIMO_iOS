//
//  TabBarStore.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/13.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct TabBarStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var tabBarItem: TabBarItem = .home
        @BindingState var isSheetPresented: Bool = false
        @BindingState var isShowToast: Bool = false
        var toastMessage: ToastModel = ToastModel(title: PIMOStrings.textCopyToastTitle,
                                                  message: PIMOStrings.textCopyToastMessage)
        var myProfile: Profile?
        var homeState = HomeStore.State()
        var uploadState = UploadStore.State()
        var myFeedState = ArchiveStore.State()
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case sendToast(ToastModel)
        case sendToastDone
        case fetchProfile
        case fetchProfileDone(Result<Profile, NetworkError>)
        case setSheetState
        case home(HomeStore.Action)
        case upload(UploadStore.Action)
        case myFeed(ArchiveStore.Action)
    }

    struct CancelID: Hashable {
        let id = String(describing: TabBarStore.self)
    }
    
    @Dependency(\.profileClient) var profileClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .sendToast(toastModel):
                if state.isShowToast {
                    return EffectTask<Action>(value: .sendToast(toastModel))
                        .delay(for: .milliseconds(1000), scheduler: DispatchQueue.main)
                        .eraseToEffect()
                } else {
                    state.isShowToast = true
                    state.toastMessage = toastModel
                    return EffectTask<Action>(value: .sendToastDone)
                        .delay(for: .milliseconds(2000), scheduler: DispatchQueue.main)
                        .eraseToEffect()
                }
            case .sendToastDone:
                state.isShowToast = false
            case .fetchProfile:
                return profileClient.fetchMyProfile()
                    .map(Action.fetchProfileDone)
                    .cancellable(id: TabBarStore.CancelID())
            case .fetchProfileDone(let result):
                switch result {
                case .success(let myProfile):
                    state.myProfile = myProfile
                case .failure(let error):
                    state.toastMessage = .init(title: error.errorDescription ?? "")
                    state.isShowToast = true
                }
            case .setSheetState:
                state.isSheetPresented = true
            case .upload(.didTapCloseButton):
                state.isSheetPresented = false

            case .home(.settingButtonDidTap):
                return .send(.home(.receiveProfileInfo(state.myProfile ?? Profile.EMPTY)))
            case .myFeed(.settingButtonDidTap):
                return .send(.myFeed(.receiveProfileInfo(state.myProfile ?? Profile.EMPTY)))
            default:
                return .none
            }

            return .none
        }
        
        Scope(state: \.homeState, action: /Action.home) {
            HomeStore()
        }
        
        Scope(state: \.uploadState, action: /Action.upload) {
            UploadStore()
        }
        
        Scope(state: \.myFeedState, action: /Action.myFeed) {
            ArchiveStore()
        }
    }
}
