//
//  ArchiveStore.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/13.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

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
        var isLoading: Bool = false
        var toastMessage: ToastModel = ToastModel(title: FIMOStrings.textCopyToastTitle,
                                                  message: FIMOStrings.textCopyToastMessage)
        var archiveType: ArchiveType = .myArchive
        var archiveProfile: FMProfile = .EMPTY
        var gridFeeds: [Feed] = []
        var feeds: IdentifiedArrayOf<FeedStore.State> = []
        var pushToSettingView: Bool = false
        var pushToFriendView: Bool = false
        var feedsType: FeedsType = .basic
        var feed: FeedStore.State?
        var feedId: Int?
        var friends: FriendsListStore.State?
        var setting: SettingStore.State?
        var bottomSheet: BottomSheetStore.State?
        var profile: ProfileSettingStore.State?
        var audioPlayingFeedId: Int?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case sendToast(ToastModel)
        case sendToastDone
        case onAppear
        case refresh
        case fetchArchiveProfile(Result<FMProfileDTO, NetworkError>)
        case fetchArchiveFeeds(Result<[FeedDTO], NetworkError>)
        case fetchFeed(Result<FeedDTO, NetworkError>)
        case feed(id: FeedStore.State.ID, action: FeedStore.Action)
        case topBarButtonDidTap
        case settingButtonDidTap
        case friendListButtonDidTap
        case feedsTypeButtonDidTap(FeedsType)
        case feedDidTap(Int)
        case receiveProfileInfo(FMProfile)
        case feedDetail(FeedStore.Action)
        case friends(FriendsListStore.Action)
        case setting(SettingStore.Action)
        case bottomSheet(BottomSheetStore.Action)
        case profile(ProfileSettingStore.Action)
        case dismissBottomSheet(Feed)
        case deleteFeed(Result<Bool, NetworkError>)
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
                    archiveClient.fetchArchiveFeeds().map {
                        Action.fetchArchiveFeeds($0)
                    }
                )
            case .refresh:
                guard let feedId = state.feedId else {
                    return archiveClient.fetchArchiveFeeds().map {
                        Action.fetchArchiveFeeds($0)
                    }
                }
                return archiveClient.fetchFeed(feedId).map {
                    Action.fetchFeed($0)
                }
            case let .fetchArchiveProfile(result):
                switch result {
                case let .success(profile):
                    state.archiveProfile = profile.toModel()
                default:
                    print("error")
                }
                state.isLoading = false
            case let .fetchArchiveFeeds(result):
                switch result {
                case let .success(feeds):
                    let feeds = feeds.map { $0.toModel() }
                    var firstFeed = 0
                    if !feeds.isEmpty { firstFeed = feeds[0].id }
                    state.gridFeeds = feeds
                    state.feeds = IdentifiedArrayOf(
                        uniqueElements: feeds.map { feed in
                            FeedStore.State(
                                textImage: feed.textImages[0],
                                id: feed.id,
                                feed: feed,
                                isFirstFeed: (firstFeed == feed.id) ? true : false,
                                clapCount: feed.clapCount,
                                isClapped: feed.isClapped
                            )
                        }
                    )
                default:
                    print("error")
                }
                state.isLoading = false
            case let .feed(id: id, action: action):
                switch action {
                case let .copyButtonDidTap(text):
                    pasteboard.string = text
                    state.isShowToast = true
                case let .moreButtonDidTap(id):
                    state.isBottomSheetPresented = true
                    state.bottomSheet = BottomSheetStore.State(feedId: id,
                                                               feed: state.feeds[id: id]?.feed ?? Feed.EMPTY,
                                                               bottomSheetType: .me)
                case .audioButtonDidTap:
                    guard let feedId = state.audioPlayingFeedId else {
                        state.audioPlayingFeedId = id
                        break
                    }
                    if state.feeds[id: feedId]?.audioButtonDidTap ?? false && feedId != id {
                        state.feeds[id: feedId]?.audioButtonDidTap.toggle()
                    }
                    state.audioPlayingFeedId = id
                default:
                    break
                }
            case let .feedDetail(action):
                switch action {
                case let .copyButtonDidTap(text):
                    pasteboard.string = text
                    state.isShowToast = true
                case let .moreButtonDidTap(id):
                    state.isBottomSheetPresented = true
                    state.bottomSheet = BottomSheetStore.State(feedId: id,
                                                               feed: state.feeds[id: id]?.feed ?? Feed.EMPTY,
                                                               bottomSheetType: .me)
                default:
                    break
                }
            case .topBarButtonDidTap:
                if state.archiveType == .myArchive {
                    #warning("내 피드 공유 (딥링크)")
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
                state.feed = nil
                state.feedId = nil
                TTSManager.shared.stopPlaying()
                if type == .basic {
                    return archiveClient.fetchArchiveFeeds().map {
                        Action.fetchArchiveFeeds($0)
                    }
                }
            case let .bottomSheet(action):
                switch action {
                case let .editButtonDidTap(feed):
                    state.isBottomSheetPresented = false
                    return EffectTask<Action>(value: .dismissBottomSheet(feed))
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
                    archiveName: state.setting?.profile.archiveName ?? "",
                    selectedImageURL: state.setting?.profile.profileImageUrl ?? ""
                )
                state.path.append(.modifyProfile)
            case let .deleteFeed(result):
                switch result {
                case .success:
                    return .send(.onAppear)
                default:
                    print("error")
                }
            case let .feedDidTap(feedId):
                state.isLoading = true
                state.feedId = feedId
                return archiveClient.fetchFeed(feedId).map {
                    Action.fetchFeed($0)
                }
            case let .fetchFeed(result):
                switch result {
                case let .success(feed):
                    let feed = feed.toModel()
                    state.feed = FeedStore.State(
                        textImage: feed.textImages[0],
                        id: feed.id,
                        feed: feed,
                        isFirstFeed: true,
                        clapCount: feed.clapCount,
                        isClapped: feed.isClapped
                    )
                default:
                    print("error")
                }
                state.isLoading = false
            default:
                break
            }
            return .none
        }
        .ifLet(\.setting, action: /Action.setting) {
            SettingStore()
        }
        .ifLet(\.feed, action: /Action.feedDetail) {
            FeedStore()
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
        .forEach(\.feeds, action: /Action.feed(id:action:)) {
            FeedStore()
        }
    }
}
