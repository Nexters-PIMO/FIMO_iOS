//
//  ArchiveStore.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/13.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import FirebaseDynamicLinks

enum ArchiveType {
    case myArchive
    case otherArchive
}

enum FeedsType {
    case basic
    case grid
}

enum FrinedType {
    case both
    case me
    case other
    case neither
}

enum ArchiveScene: Hashable {
    case archive
    case friends
    case setting
    case openSourceLicence
    case modifyProfile
}

struct ArchiveStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var path: [ArchiveScene] = []
        @BindingState var isShowToast: Bool = false
        @BindingState var isBottomSheetPresented = false
        @BindingState var isShareSheetPresented = false
        var isLoading: Bool = false
        var toastMessage: ToastModel = ToastModel(title: FIMOStrings.textCopyToastTitle,
                                                  message: FIMOStrings.textCopyToastMessage)
        var archiveType: ArchiveType = .myArchive
        var archiveProfile: FMProfile = .EMPTY
        var gridPosts: [FMPost] = []
        var posts: IdentifiedArrayOf<PostStore.State> = []
        var pushToSettingView: Bool = false
        var pushToFriendView: Bool = false
        var feedsType: FeedsType = .basic
        var post: PostStore.State?
        var postId: String?
        var friends: FriendsListStore.State?
        var setting: SettingStore.State?
        var bottomSheet: BottomSheetStore.State?
        var profile: ProfileSettingStore.State?
        var audioPlayingPostId: String?
        var userId: String = ""
        var link: String = ""
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case sendToast(ToastModel)
        case sendToastDone
        case onAppear
        case refresh
        case fetchArchiveProfile(Result<FMProfileDTO, NetworkError>)
        case fetchArchivePosts(Result<[FMPostDTO], NetworkError>)
        case fetchPost(Result<FMPostDTO, NetworkError>)
        case post(id: PostStore.State.ID, action: PostStore.Action)
        case topBarButtonDidTap
        case settingButtonDidTap
        case friendListButtonDidTap
        case feedsTypeButtonDidTap(FeedsType)
        case postDidTap(String)
        case receiveProfileInfo(FMProfile)
        case postDetail(PostStore.Action)
        case friends(FriendsListStore.Action)
        case setting(SettingStore.Action)
        case bottomSheet(BottomSheetStore.Action)
        case profile(ProfileSettingStore.Action)
        case dismissBottomSheet(FMPost)
        case deletePost(Result<FMServerDescriptionDTO, NetworkError>)
        case createLink
        case fetchLink(TaskResult<String>)
    }
    
    @Dependency(\.archiveClient) var archiveClient
    @Dependency(\.profileClient) var profileClient
    
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
                return .merge(
                    profileClient.myProfile().map {
                        Action.fetchArchiveProfile($0)
                    },
                    archiveClient.archivePosts(state.userId).map {
                        Action.fetchArchivePosts($0)
                    }
                )
                
            case .refresh:
                guard let postId = state.postId else {
                    return archiveClient.archivePosts(state.userId).map {
                        Action.fetchArchivePosts($0)
                    }
                }
                return archiveClient.post(postId).map {
                    Action.fetchPost($0)
                }
                
            case let .fetchArchiveProfile(result):
                switch result {
                case let .success(profile):
                    state.archiveProfile = profile.toModel()
                default:
                    print("error")
                }
                state.isLoading = false
                
            case let .fetchArchivePosts(result):
                switch result {
                case let .success(posts):
                    let posts = posts.map { $0.toModel() }
                    var firstPost = ""
                    if !posts.isEmpty { firstPost = posts[0].id }
                    state.gridPosts = posts
                    state.posts = IdentifiedArrayOf(
                        uniqueElements: posts.map { post in
                            PostStore.State(
                                textImage: post.items[0],
                                id: post.id,
                                post: post,
                                isFirstPost: (firstPost == post.id) ? true : false,
                                clapCount: post.favorite,
                                isClapped: post.isClicked
                            )
                        }
                    )
                    return .send(.createLink)
                    
                default:
                    print("error")
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
                
            case let .postDetail(action):
                switch action {
                case let .copyButtonDidTap(text):
                    pasteboard.string = text
                    state.isShowToast = true
                case let .moreButtonDidTap(id):
                    state.isBottomSheetPresented = true
                    state.bottomSheet = BottomSheetStore.State(postId: id,
                                                               post: state.posts[id: id]?.post ?? FMPost.EMPTY,
                                                               bottomSheetType: .me)
                default:
                    break
                }
            case .topBarButtonDidTap:
                if state.archiveType == .myArchive {
                    state.isShareSheetPresented = true
                } else {
#warning("친구 서버 (POST)")
                }
                break
            case .receiveProfileInfo(let profile):
                state.setting = SettingStore.State(profile: profile)
                state.path.append(.setting)
            case .setting(.tappedLicenceButton):
                state.path.append(.openSourceLicence)
            case .friendListButtonDidTap:
                state.pushToFriendView = true
#warning("Friend List 받아오는 매개변수 주입 필요")
                state.friends = FriendsListStore.State(id: 0, userName: state.archiveProfile.nickname)
                state.path.append(.friends)
            case let .feedsTypeButtonDidTap(type):
                state.feedsType = type
                state.post = nil
                state.postId = nil
                TTSManager.shared.stopPlaying()
                if type == .basic {
                    return archiveClient.archivePosts(state.userId).map {
                        Action.fetchArchivePosts($0)
                    }
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
                
            case let .deletePost(result):
                switch result {
                case .success:
                    return .send(.onAppear)
                default:
                    print("error")
                }
                
            case let .postDidTap(postId):
                state.isLoading = true
                state.postId = postId
                return archiveClient.post(postId).map {
                    Action.fetchPost($0)
                }
                
            case let .fetchPost(result):
                switch result {
                case let .success(post):
                    let post = post.toModel()
                    state.post = PostStore.State(
                        textImage: post.items[0],
                        id: post.id,
                        post: post,
                        isFirstPost: true,
                        clapCount: post.favorite,
                        isClapped: post.isClicked
                    )
                default:
                    print("error")
                }
                state.isLoading = false
                
            case .createLink:
                return .run { [userId = state.userId] send in
                    await send(.fetchLink(
                        TaskResult { try await DynamicLinkUtil.createDynamicLink(userId: userId) }
                        )
                    )
                }
                
            case let .fetchLink(.success(linkURL)):
                let content = state.posts.first?.textImage.content ?? ""
                let link = """
                              \(content)
                              \n\(state.archiveProfile.nickname)님의 [\(state.archiveProfile.archiveName)] 아카이브를 구경해보세요.
                              \(linkURL)
                              """
                state.link = link
                
            default:
                break
            }
            return .none
        }
        .ifLet(\.setting, action: /Action.setting) {
            SettingStore()
        }
        .ifLet(\.post, action: /Action.postDetail) {
            PostStore()
        }
        .ifLet(\.friends, action: /Action.friends) {
            FriendsListStore()
        }
        .ifLet(\.bottomSheet, action: /Action.bottomSheet) {
            BottomSheetStore()
        }
        .ifLet(\.profile, action: /Action.profile) {
            ProfileSettingStore()
        }
        .forEach(\.posts, action: /Action.post(id:action:)) {
            PostStore()
        }
    }
}
