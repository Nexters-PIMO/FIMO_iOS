//
//  HomeStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import ComposableArchitecture

enum HomeScene: Hashable {
    case home
    case setting
}

struct HomeStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var path: [HomeScene] = []
        var feeds: IdentifiedArrayOf<FeedStore.State> = []
        var setting: SettingStore.State?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case fetchFeeds
        case feed(id: FeedStore.State.ID, action: FeedStore.Action)
        case settingButtonDidTap
        case receiveProfileInfo(Profile)
        case setting(SettingStore.Action)
    }
    
    @Dependency(\.homeClient) var homeClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
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
                break
            case .receiveProfileInfo(let profile):
                // TODO: API 연결 시 보완 예정
                state.setting = SettingStore.State(nickname: profile.nickName,
                                                   archiveName: "",
                                                   imageURLString: profile.imageURL)
                state.path.append(.setting)
            default:
                break
            }
            return .none
        }
        .ifLet(\.setting, action: /Action.setting) {
            SettingStore()
        }
        .forEach(\.feeds, action: /Action.feed(id:action:)) {
            FeedStore()
        }
    }
}
