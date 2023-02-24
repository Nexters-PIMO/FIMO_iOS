//
//  HomeStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import ComposableArchitecture

struct HomeStore: ReducerProtocol {
    struct State: Equatable {
        var feeds: IdentifiedArrayOf<FeedStore.State> = []
    }
    
    enum Action: Equatable {
        case fetchFeeds
        case feed(id: FeedStore.State.ID, action: FeedStore.Action)
    }
    
    @Dependency(\.homeClient) var homeClient
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchFeeds:
                let feeds = homeClient.fetchFeeds()
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
            }
            return .none
        }
        .forEach(\.feeds, action: /Action.feed(id:action:)) {
            FeedStore()
        }
    }
}
