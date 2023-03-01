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
        var isFirstFeed: Bool = false
        @BindingState var textImage: TextImage = TextImage.EMPTY
        var clapCount: Int = 0
        var clapButtonDidTap: Bool = false
        var audioButtonDidTap: Bool = false
        var closeButtonDidTap: Bool = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case checkTextGuideClosed
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
            case .checkTextGuideClosed:
                guard let isClosed = UserUtill.shared.getClosedTextGuide() else {
                    state.closeButtonDidTap = false
                    return .none
                }
                state.closeButtonDidTap = isClosed
            case .moreButtonDidTap:
                #warning("바텀시트")
            case let .copyButtonDidTap(text):
                #warning("텍스트 복사")
            case .closeButtonDidTap:
                UserUtill.shared.setUserDefaults(key: .closedTextGuide, value: true)
                state.closeButtonDidTap = true
            case .clapButtonDidTap:
                state.clapCount += 1
                state.clapButtonDidTap = true
            case .shareButtonDidTap:
                #warning("딥링크")
            case let .audioButtonDidTap(text):
                #warning("TTS")
                state.audioButtonDidTap.toggle()
            default:
                break
            }
            return .none
        }
    }
}
