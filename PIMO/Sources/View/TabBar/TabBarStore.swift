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
        @BindingState var isShowRemovePopup: Bool = false
        @BindingState var isShowAcceptBackPopup: Bool = false
        var toastMessage: ToastModel = ToastModel(title: PIMOStrings.textCopyToastTitle,
                                                  message: PIMOStrings.textCopyToastMessage)
        var myProfile: Profile?
        var homeState = HomeStore.State()
        var uploadState = UploadStore.State()
        var archiveState = ArchiveStore.State()
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
        case archive(ArchiveStore.Action)
        case deleteFeed
        case acceptBackOnProfileSetting
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
            case .home(.bottomSheet(.deleteButtonDidTap(let feedId))):
                state.isShowRemovePopup = true
                let _ = print(feedId)
            case .archive(.settingButtonDidTap):
                return .send(.archive(.receiveProfileInfo(state.myProfile ?? Profile.EMPTY)))
            case .archive(.bottomSheet(.deleteButtonDidTap(let feedId))):
                state.isShowRemovePopup = true
                let _ = print(feedId)
            case .acceptBackOnProfileSetting:
                if state.tabBarItem == .home,
                   state.homeState.path.last == .modifyProfile {
                    state.homeState.path.removeLast()
                } else if state.tabBarItem == .myFeed,
                          state.archiveState.path.last == .modifyProfile {
                    state.archiveState.path.removeLast()
                }
            case .home(.profile(.tappedBackButton)):
                state.isShowAcceptBackPopup = true
                return .none
            case .archive(.profile(.tappedBackButton)):
                state.isShowAcceptBackPopup = true
                return .none
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
        
        Scope(state: \.archiveState, action: /Action.archive) {
            ArchiveStore()
        }
    }
}
