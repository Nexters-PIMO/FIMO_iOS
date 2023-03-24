//
//  TabBarStore.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/13.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

enum DeleteAt {
    case home
    case archive
}

struct TabBarStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var tabBarItem: TabBarItem = .home
        @BindingState var isSheetPresented: Bool = false
        @BindingState var isShowToast: Bool = false
        @BindingState var isShowRemovePopup: Bool = false
        var toastMessage: ToastModel = ToastModel(title: PIMOStrings.textCopyToastTitle,
                                                  message: PIMOStrings.textCopyToastMessage)
        var myProfile: Profile?
        var homeState = HomeStore.State()
        var uploadState = UploadStore.State()
        var archiveState = ArchiveStore.State()
        var feedId: Int?
        var deleteAt: DeleteAt?
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
    }

    struct CancelID: Hashable {
        let id = String(describing: TabBarStore.self)
    }
    
    @Dependency(\.profileClient) var profileClient
    @Dependency(\.feedClient) var feedClient
    
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
                state.feedId = feedId
                state.deleteAt = .home
            case .archive(.settingButtonDidTap):
                return .send(.archive(.receiveProfileInfo(state.myProfile ?? Profile.EMPTY)))
            case .archive(.bottomSheet(.deleteButtonDidTap(let feedId))):
                state.isShowRemovePopup = true
                state.feedId = feedId
                state.deleteAt = .archive
            case .deleteFeed:
                guard let feedId = state.feedId else {
                    return .none
                }
                
                if state.deleteAt == .home {
                    return feedClient.deleteFeed(feedId).map {
                        Action.home(.deleteFeed($0))
                    }
                } else {
                    return feedClient.deleteFeed(feedId).map {
                        Action.archive(.deleteFeed($0))
                    }
                }
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
