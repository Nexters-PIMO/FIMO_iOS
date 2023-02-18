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
        var feeds: [Feed] = []
    }
    
    enum Action: Equatable {
        case fetchFeeds
    }
    
    @Dependency(\.homeClient) var homeClient
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchFeeds:
                state.feeds = homeClient.fetchFeeds()
            }
            return .none
        }
    }
}
