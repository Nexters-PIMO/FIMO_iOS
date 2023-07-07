//
//  HomeStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

enum HomeScene: Hashable {
    case home
    case setting
    case openSourceLicence
    case modifyProfile
}

struct HomeStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var path: [HomeScene] = []
        @BindingState var isShowToast: Bool = false
        @BindingState var isBottomSheetPresented: Bool = false
        var isLoading: Bool = false
        var toastMessage: ToastModel = ToastModel(title: FIMOStrings.textCopyToastTitle,
                                                  message: FIMOStrings.textCopyToastMessage)
        var posts: IdentifiedArrayOf<PostStore.State> = []
        var setting: SettingStore.State?
        var bottomSheet: BottomSheetStore.State?
        var profile: ProfileSettingStore.State?
        var audioPlayingPostId: String?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case onAppear
        case refresh
        case sendToast(ToastModel)
        case sendToastDone
        case fetchPosts(Result<[FMPostDTO], NetworkError>)
        case fetchPostProfile(Result<Profile, NetworkError>)
        case post(id: PostStore.State.ID, action: PostStore.Action)
        case settingButtonDidTap
        case receiveProfileInfo(FMProfile)
        case setting(SettingStore.Action)
        case onboarding(OnboardingStore.Action)
        case bottomSheet(BottomSheetStore.Action)
        case profile(ProfileSettingStore.Action)
        case dismissBottomSheet(FMPost)
        case deletePost(Result<FMServerDescriptionDTO, NetworkError>)
    }
    
    @Dependency(\.homeClient) var homeClient
    
    private let pasteboard = UIPasteboard.general
    
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
            case .onAppear:
                state.isLoading = true
                return homeClient.posts().map {
                    Action.fetchPosts($0)
                }
            case .refresh:
                return homeClient.posts().map {
                    Action.fetchPosts($0)
                }
            case let .fetchPosts(result):
                switch result {
                case let .success(posts):
                    var firstPost = ""
                    if !posts.isEmpty { firstPost = posts[0].id }
                    state.posts = IdentifiedArrayOf(
                        uniqueElements: posts.map { $0.toModel() }.map { post in
                            PostStore.State(
                                textImage: post.items[0],
                                id: post.id,
                                post: post,
                                isFirstPost: (post.id == firstPost) ? true : false,
                                clapCount: post.favorite,
                                isClapped: post.isClicked
                            )
                        }
                    )
                default:
                    break
                }
                state.isLoading = false
            case let .post(id: id, action: action):
                switch action {
                case let .copyButtonDidTap(text):
                    pasteboard.string = text
                    state.isShowToast = true
                case let .moreButtonDidTap(id):
                    state.isBottomSheetPresented = true
                    state.bottomSheet = BottomSheetStore.State(postId: id,
                                                               post: state.posts[id: id]?.post ?? FMPost.EMPTY,
                                                               bottomSheetType: .me)
                case .audioButtonDidTap:
                    guard let postId = state.audioPlayingPostId else {
                        state.audioPlayingPostId = id
                        break
                    }
                    if state.posts[id: postId]?.audioButtonDidTap ?? false && postId != id {
                        state.posts[id: postId]?.audioButtonDidTap.toggle()
                    }
                    state.audioPlayingPostId = id
                default:
                    break
                }
            case let .bottomSheet(action):
                switch action {
                case let .editButtonDidTap(post):
                    state.isBottomSheetPresented = false
                    return EffectTask<Action>(value: .dismissBottomSheet(post))
                        .delay(for: .seconds(0.3), scheduler: DispatchQueue.main)
                        .eraseToEffect()
                case .deleteButtonDidTap:
                    state.isBottomSheetPresented = false
                case .declationButtonDidTap:
                    state.isBottomSheetPresented = false
                }
            case let .deletePost(result):
                switch result {
                case .success:
                    return .send(.onAppear)
                default:
                    print("error")
                }
            case .receiveProfileInfo(let profile):
                state.setting = SettingStore.State(profile: profile)
                state.path.append(.setting)
            case .setting(.tappedLicenceButton):
                state.path.append(.openSourceLicence)
            case .setting(.tappedProfileManagementButton):
                state.profile = ProfileSettingStore.State(
                    nickname: state.setting?.profile.nickname ?? "",
                    previousNickname: state.setting?.profile.nickname ?? "",
                    archiveName: state.setting?.profile.archiveName ?? "",
                    previousArchiveName: state.setting?.profile.archiveName ?? "",
                    selectedImageURL: state.setting?.profile.profileImageUrl ?? "",
                    previousSelectedImageURL: state.setting?.profile.profileImageUrl ?? ""
                )
                state.path.append(.modifyProfile)
            default:
                break
            }
            return .none
        }
        .ifLet(\.setting, action: /Action.setting) {
            SettingStore()
        }
        .ifLet(\.bottomSheet, action: /Action.bottomSheet) {
            BottomSheetStore()
        }
        .forEach(\.posts, action: /Action.post(id:action:)) {
            PostStore()
        }
        .ifLet(\.profile, action: /Action.profile) {
            ProfileSettingStore()
        }
    }
}
