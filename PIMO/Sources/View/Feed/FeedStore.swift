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
        var id: Int = 0
        var feed: Feed = Feed.EMPTY
        @BindingState var textImage: TextImage = TextImage.EMPTY
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
            case .moreButtonDidTap:
                // TODO: 바텀시트
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
            return .none
        }
    }
}
