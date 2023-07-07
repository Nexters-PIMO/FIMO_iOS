//
//  HomeService.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/26.
//  Copyright © 2023 pimo. All rights reserved.
//

import Combine
import Foundation

import ComposableArchitecture

struct HomeClient {
    #warning("새로운 API로 삭제 예정")
    let fetchFeeds: () -> EffectPublisher<Result<[FeedDTO], NetworkError>, Never>

    let posts: () -> EffectPublisher<Result<[FMPostDTO], NetworkError>, Never>
}

extension DependencyValues {
    var homeClient: HomeClient {
        get { self[HomeClient.self] }
        set { self[HomeClient.self] = newValue }
    }
}

extension HomeClient: DependencyKey {
    static let liveValue = Self.init(
        fetchFeeds: {
            let request = FeedsRequest(target: .fetchHomeFeeds)
            
            return BaseNetwork.shared.request(api: request, isInterceptive: false)
                .catchToEffect()
        }, posts: {
            let request = FMAllFeedRequest()

            return BaseNetwork.shared.request(api: request, isInterceptive: false)
                .catchToEffect()
        })
}
