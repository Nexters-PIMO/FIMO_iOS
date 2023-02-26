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
        var feeds: IdentifiedArrayOf<FeedStore.State> = []
        var pushToSettingView: Bool = false
        var pushToFriendView: Bool = false
        var feedsType: FeedsType = .basic
    }
    
    enum Action: Equatable {
        case fetchArchive
        case feed(id: FeedStore.State.ID, action: FeedStore.Action)
        case topBarButtonDidTap
        case settingButtonDidTap
        case friendListButtonDidTap
        case feedsTypeButtonDidTap(FeedsType)
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
                switch action {
                case .moreButtonDidTap:
                    // TODO: 바텀시트
                    let _ = print("feedId \(id)")
                    let _ = print("more")
                case let .copyButtonDidTap(text):
                    // TODO: 텍스트 복사
                    let _ = print("\(text)")
                case .closeButtonDidTap:
                    // TODO: 텍스트 닫기 (UserDefault)
                    let _ = print("close")
                case .clapButtonDidTap:
                    let _ = print("clap")
                case .shareButtonDidTap:
                    // TODO: 딥링크
                    let _ = print("share")
                case let .audioButtonDidTap(text):
                    // TODO: TTS
                    let _ = print("\(text)")
                default:
                    break
                }
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
            }
            return .none
        }
        .forEach(\.feeds, action: /Action.feed(id:action:)) {
            FeedStore()
        }
    }
}
