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
        var clapCount: Int = 0
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case fetchFeeds
        case moreButtonDidTap
        case copyButtonDidTap
        case closeButtonDidTap
        case clapButtonDidTap
        case shareButtonDidTap
        case audioButtonDidTap
    }
    
    @Dependency(\.homeClient) var homeClient
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .fetchFeeds:
                state.feeds = homeClient.fetchFeeds()
            case .moreButtonDidTap:
                // TODO: 바텀시트
                let _ = print("more")
            case .copyButtonDidTap:
                // TODO: 텍스트 복사
                let _ = print("copy")
            case .closeButtonDidTap:
                // TODO: 텍스트 닫기 (UserDefault)
                let _ = print("close")
            case .clapButtonDidTap:
                state.clapCount += 1
                let _ = print("clap")
            case .shareButtonDidTap:
                // TODO: 딥링크
                let _ = print("share")
            case .audioButtonDidTap:
                // TODO: TTS
                let _ = print("audio")
            }
            return .none
        }
    }
}
