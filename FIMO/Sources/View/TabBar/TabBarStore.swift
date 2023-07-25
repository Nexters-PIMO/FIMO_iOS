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
        @BindingState var isShowAcceptBackPopup: Bool = false
        @BindingState var isShowLogoutPopup: Bool = false
        @BindingState var isShowWithdrawalPopup: Bool = false
        @BindingState var isShowFriendshipPopup: Bool = false
        var toastMessage: ToastModel = ToastModel(title: FIMOStrings.textCopyToastTitle,
                                                  message: FIMOStrings.textCopyToastMessage)
        var myProfile: FMProfile?
        var homeState = HomeStore.State()
        var uploadState = UploadStore.State()
        var archiveState = ArchiveStore.State()
        var postId: String?
        var deleteAt: DeleteAt?
        var selectedFriend: FMFriend?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case sendToast(ToastModel)
        case sendToastDone
        case fetchProfile
        case fetchProfileDone(Result<FMProfileDTO, NetworkError>)
        case setSheetState
        case home(HomeStore.Action)
        case upload(UploadStore.Action)
        case archive(ArchiveStore.Action)
        case deletePost
        case acceptBackOnProfileSetting
        case acceptLogout
        case acceptWithdrawal
        case acceptFriendship(FMFriend)
    }

    struct CancelID: Hashable {
        let id = String(describing: TabBarStore.self)
    }
    
    @Dependency(\.profileClient) var profileClient
    @Dependency(\.feedClient) var feedClient
    @Dependency(\.friendsClient) var friendsClient
    
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
                return profileClient.myProfile()
                    .map(Action.fetchProfileDone)
                    .cancellable(id: TabBarStore.CancelID())
            case .fetchProfileDone(let result):
                switch result {
                case .success(let myProfile):
                    state.myProfile = myProfile.toModel()
                    state.archiveState.userId = myProfile.id
                    GoogleAnalytics.shared.setUserId(myProfile.id)
                case .failure(let error):
                    state.toastMessage = .init(title: error.errorDescription ?? "")
                    state.isShowToast = true
                }
            case .setSheetState:
                GoogleAnalytics.shared.logEvent(.test)
                state.isSheetPresented = true
            case .upload(.didTapCloseButton):
                state.isSheetPresented = false
            case .home(.settingButtonDidTap):
                return .send(.home(.receiveProfileInfo(state.myProfile ?? FMProfile.EMPTY)))
            case .home(.bottomSheet(.deleteButtonDidTap(let postId))):
                state.isShowRemovePopup = true
                state.postId = postId
                state.deleteAt = .home
            case .archive(.settingButtonDidTap):
                return .send(.archive(.receiveProfileInfo(state.myProfile ?? FMProfile.EMPTY)))
            case .archive(.bottomSheet(.deleteButtonDidTap(let postId))):
                state.isShowRemovePopup = true
                state.postId = postId
                state.deleteAt = .archive
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

                // MARK: Home

            case let .home(action):
                switch action {
                case .settingButtonDidTap:
                    return .send(.home(.receiveProfileInfo(state.myProfile ?? FMProfile.EMPTY)))
                case let .bottomSheet(.deleteButtonDidTap(postId)):
                    state.isShowRemovePopup = true
                    state.postId = postId
                    state.deleteAt = .home
                case let .dismissBottomSheet(post):
                    print(post)
                    state.isSheetPresented = true
                    state.uploadState.uploadedPostItems = post.items
                    state.uploadState.selectedPostItem = post.items.first
                case .setting(.tappedLogoutButton):
                    state.isShowLogoutPopup = true
                case .setting(.tappedWithdrawalButton):
                    state.isShowWithdrawalPopup = true
                case .profile(.modifyProfileDone(let result)):
                    switch result {
                    case .success(let profileDTO):
                        let profile = profileDTO.toModel()
                        state.myProfile = profile
                        state.archiveState.archiveProfile = profile
                        state.homeState.setting?.profile = profile
                        state.homeState.path.removeLast()
                        return .none
                    case .failure(let error):
                        return .init(value: .sendToast(ToastModel(title: error.errorDescription ?? "")))
                    }
                default:
                    break
                }

                // MARK: Archive

            case let .archive(action):
                switch action {
                case .settingButtonDidTap:
                    return .send(.archive(.receiveProfileInfo(state.myProfile ?? FMProfile.EMPTY)))
                case let .bottomSheet(.deleteButtonDidTap(postId)):
                    state.isShowRemovePopup = true
                    state.postId = postId
                    state.deleteAt = .archive
                case let .dismissBottomSheet(post):
                    state.isSheetPresented = true
                    state.uploadState.uploadedPostItems = post.items
                    state.uploadState.selectedPostItem = post.items.first
                case .setting(.tappedLogoutButton):
                    state.isShowLogoutPopup = true
                case .setting(.tappedWithdrawalButton):
                    state.isShowWithdrawalPopup = true
                case .friends(.tappedRequestFriendButton(let friend)):
                    state.selectedFriend = friend
                    state.isShowFriendshipPopup = true
                    return .none
                case .profile(.modifyProfileDone(let result)):
                    switch result {
                    case .success(let profileDTO):
                        let profile = profileDTO.toModel()
                        state.myProfile = profile
                        state.archiveState.archiveProfile = profile
                        state.archiveState.setting?.profile = profile
                        state.archiveState.path.removeLast()
                        return .none
                    case .failure(let error):
                        return .init(value: .sendToast(ToastModel(title: error.errorDescription ?? "")))
                    }
                default:
                    break
                }
            case .acceptFriendship(let friend):
                switch friend.friendType.friendshipInteraction {
                case .follow:
                    return friendsClient.followFriend(friend.id).map {
                        Action.archive(.friends(.tappedRequestFriendDone(friend, $0)))
                    }
                case .unfollow:
                    return friendsClient.unfollowFriend(friend.id).map {
                        Action.archive(.friends(.tappedRequestFriendDone(friend, $0)))
                    }
                }
            case .deletePost:
                guard let postId = state.postId else {
                    return .none
                }
                
                if state.deleteAt == .home {
                    return feedClient.deletePost(postId).map {
                        Action.home(.deletePost($0))
                    }
                } else {
                    return feedClient.deletePost(postId).map {
                        Action.archive(.deletePost($0))
                    }
                }
            case .upload(.didTapPublishButtonDone(let result)):
                if case .success = result {
                    state.isSheetPresented = false

                    let effects: [EffectTask<TabBarStore.Action>] = [
                        .init(value: .home(.onAppear)),
                        .init(value: .archive(.onAppear))
                    ]

                    return .merge(effects)
                }
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
