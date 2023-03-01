//
//  ArchiveStore.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/13.
//  Copyright © 2023 pimo. All rights reserved.
//

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
        var archiveType: ArchiveType = .myArchive
        var archiveInfo: ArchiveInfo = .EMPTY
        var gridFeeds: [Feed] = []
        var feeds: IdentifiedArrayOf<FeedStore.State> = []
        var pushToSettingView: Bool = false
        var pushToFriendView: Bool = false
        var feedsType: FeedsType = .basic
        var feed: FeedStore.State?
    }
    
    enum Action: Equatable {
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
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchArchive:
                let archive = archiveClient.fetchArchive()
                let archiveInfo = archive.archiveInfo
                let feeds = archive.feeds
                state.archiveInfo = archiveInfo
                state.gridFeeds = archive.feeds
                state.feeds = IdentifiedArrayOf(
                    uniqueElements: feeds.map { feed in
                        FeedStore.State(
                            id: feed.id,
                            feed: feed,
                            textImage: feed.textImages[0],
                            clapButtonDidTap: feed.isClapped
                        )
                    }
                )
            case let .feed(id: id, action: action):
                break
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
                    id: feed.id,
                    feed: feed,
                    textImage: feed.textImages[0],
                    clapCount: feed.clapCount,
                    clapButtonDidTap: feed.isClapped
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
