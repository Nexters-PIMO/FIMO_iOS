//
//  FeedClient.swift
//  PIMO
//
//  Created by 김영인 on 2023/03/19.
//  Copyright © 2023 pimo. All rights reserved.
//

import Combine
import Foundation

import ComposableArchitecture

struct FeedClient {
    let play: (String) -> EffectPublisher<Void, Never>
    let stop: () -> EffectPublisher<Void, Never>
    let postClap: (String) -> EffectPublisher<Result<Bool, NetworkError>, Never>
    let deleteFeed: (String) -> EffectPublisher<Result<Bool, NetworkError>, Never>
}

extension DependencyValues {
    var feedClient: FeedClient {
        get { self[FeedClient.self] }
        set { self[FeedClient.self] = newValue }
    }
}

extension FeedClient: DependencyKey {
    static var liveValue: Self {
        return Self(
            play: { text in TTSManager.shared.play(text) },
            stop: { TTSManager.shared.stop() },
            postClap: { feedId in
                let request = FMPostActionRequest(target: .postClap(feedId))
                
                return BaseNetwork.shared.requestWithNoResponse(api: request, isInterceptive: false)
                    .catchToEffect()
            },
            deleteFeed: { feedId in
                let request = FMPostActionRequest(target: .deleteFeed(feedId))
                
                return BaseNetwork.shared.requestWithNoResponse(api: request, isInterceptive: false)
                    .catchToEffect()
            }
        )
    }
}
