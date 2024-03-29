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

    #warning("새로운 API로 제거 예정")
    let postClap: (Int) -> EffectPublisher<Result<Bool, NetworkError>, Never>
    let deleteFeed: (Int) -> EffectPublisher<Result<Bool, NetworkError>, Never>

    let clap: (String) -> EffectPublisher<Result<Int, NetworkError>, Never>
    let deletePost: (String) -> EffectPublisher<Result<FMServerDescriptionDTO, NetworkError>, Never>
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
                let request = FeedActionRequest(target: .postClap(feedId))
                
                return BaseNetwork.shared.requestWithNoResponse(api: request, isInterceptive: false)
                    .catchToEffect()
            },
            deleteFeed: { feedId in
                let request = FeedActionRequest(target: .deleteFeed(feedId))
                
                return BaseNetwork.shared.requestWithNoResponse(api: request, isInterceptive: false)
                    .catchToEffect()
            }, clap: { id in
                let request = FMPostFavoriteRequest(postId: id)

                return BaseNetwork.shared.request(api: request, isInterceptive: false)
                    .catchToEffect()
            }, deletePost: { id in
                let request = FMDeletePostRequest(postId: id)

                return BaseNetwork.shared.request(api: request, isInterceptive: false)
                    .catchToEffect()
            }
        )
    }
}
