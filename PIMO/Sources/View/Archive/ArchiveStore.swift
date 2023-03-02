//
//  ArchiveStore.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/13.
//  Copyright © 2023 pimo. All rights reserved.
//

import UIKit

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

struct ArchiveStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var isShowToast: Bool = false
        var toastMessage: ToastModel = ToastModel(title: PIMOStrings.textCopyToastTitle,
                                                  message: PIMOStrings.textCopyToastMessage)
        var archiveType: ArchiveType = .myArchive
        var archiveInfo: ArchiveInfo = .EMPTY
        var gridFeeds: [Feed] = []
        var feeds: IdentifiedArrayOf<FeedStore.State> = []
        var pushToSettingView: Bool = false
        var pushToFriendView: Bool = false
        var feedsType: FeedsType = .basic
        var feed: FeedStore.State?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case sendToast(ToastModel)
        case sendToastDone
        case fetchArchive
        case feed(id: FeedStore.State.ID, action: FeedStore.Action)
        case topBarButtonDidTap
        case settingButtonDidTap
        case friendListButtonDidTap
        case feedsTypeButtonDidTap(FeedsType)
        case feedDidTap(Feed)
        case feedDetail(FeedStore.Action)
    }
    
    @Dependency(\.archiveClient) var archiveClient
    
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
            case .fetchArchive:
                let archive = archiveClient.fetchArchive()
                let archiveInfo = archive.archiveInfo
                let feeds = archive.feeds
                var firstFeed = 0
                if !feeds.isEmpty { firstFeed = feeds[0].id }
                state.archiveInfo = archiveInfo
                state.gridFeeds = archive.feeds
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
            case let .feed(id: _, action: action):
                switch action {
                case let .copyButtonDidTap(text):
                    pasteboard.string = text
                    state.isShowToast = true
                default:
                    break
                }
            case let .feedDetail(.copyButtonDidTap(text)):
                pasteboard.string = text
                state.isShowToast = true
            case .topBarButtonDidTap:
                if state.archiveType == .myArchive {
                    // TODO: 내 피드 공유 (딥링크)
                } else {
                    // TODO: 친구 서버 (POST)
                }
                break
            case .settingButtonDidTap:
                state.pushToSettingView = true
            case .friendListButtonDidTap:
                state.pushToFriendView = true
            case let .feedsTypeButtonDidTap(type):
                state.feedsType = type
                state.feed = nil
            case let .feedDidTap(feed):
                state.feed = FeedStore.State(
                    textImage: feed.textImages[0],
                    id: feed.id,
                    feed: feed,
                    isFirstFeed: true,
                    clapCount: feed.clapCount,
                    isClapped: feed.isClapped
                )
            default:
                break
            }
            return .none
        }
        .ifLet(\.feed, action: /Action.feedDetail) {
            FeedStore()
        }
        .forEach(\.feeds, action: /Action.feed(id:action:)) {
            FeedStore()
        }
    }
}
