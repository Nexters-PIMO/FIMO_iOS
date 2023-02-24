//
//  FeedStore.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/24.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import ComposableArchitecture

struct FeedStore: ReducerProtocol {
    struct State: Equatable, Identifiable {
        var id: Int
        var feed: Feed = .init()
        @BindableState var textImage: TextImage = .init()
        var clapCount: Int = 0
        var clapButtonDidTap: Bool = false
        var audioButtonDidTap: Bool = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case moreButtonDidTap(Int)
        case copyButtonDidTap(String)
        case closeButtonDidTap
        case clapButtonDidTap
        case shareButtonDidTap
        case audioButtonDidTap(String)
    }
    
    private enum FeedID { }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                break
            case .clapButtonDidTap:
                state.clapCount += 1
            case .audioButtonDidTap:
                state.audioButtonDidTap.toggle()
            default:
                break
            }
            return .none
        }
    }
}
