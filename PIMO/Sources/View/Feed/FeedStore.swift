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
        case moreButtonDidTap
        case copyButtonDidTap
        case closeButtonDidTap
        case clapButtonDidTap
        case shareButtonDidTap
        case audioButtonDidTap
    }
    
    private enum FeedID { }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
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
                state.audioButtonDidTap.toggle()
                let _ = print("audio")
            }
            return .none
        }
    }
}
