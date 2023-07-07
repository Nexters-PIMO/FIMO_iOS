//
//  ArchiveClient.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/25.
//  Copyright © 2023 pimo. All rights reserved.
//

import Combine
import Foundation

import ComposableArchitecture

struct ArchiveClient {
    #warning("새로운 API로 삭제 예정")
    let fetchProfile: () -> EffectPublisher<Result<Profile, NetworkError>, Never>
    let fetchArchiveFeeds: () -> EffectPublisher<Result<[FeedDTO], NetworkError>, Never>
    let fetchFeed: (Int) -> EffectPublisher<Result<FeedDTO, NetworkError>, Never>

    let archivePosts: () -> EffectPublisher<Result<[FMPostDTO], NetworkError>, Never>
    let post: (String) -> EffectPublisher<Result<FMPostDTO, NetworkError>, Never>
}

extension DependencyValues {
    var archiveClient: ArchiveClient {
        get { self[ArchiveClient.self] }
        set { self[ArchiveClient.self] = newValue }
    }
}

extension ArchiveClient: DependencyKey {
    static let liveValue = Self.init(
        fetchProfile: {
            let request = ProfileRequest(target: .fetchMyProfile)
            
            return BaseNetwork.shared.request(api: request, isInterceptive: false)
                .catchToEffect()
        }, fetchArchiveFeeds: {
            let request = FeedsRequest(target: .fetchArchiveFeeds)
            
            return BaseNetwork.shared.request(api: request, isInterceptive: false)
                .catchToEffect()
        }, fetchFeed: { feedId in
            let request = FeedRequest(feedId: feedId)
            
            return BaseNetwork.shared.request(api: request, isInterceptive: false)
                .catchToEffect()
        }, archivePosts: {
            let request = FMAllPostRequest(target: .me)

            return BaseNetwork.shared.request(api: request, isInterceptive: true)
                .catchToEffect()
        }, post: { id in
            let request = FMPostDetailRequest(postId: id)

            return BaseNetwork.shared.request(api: request, isInterceptive: true)
                .catchToEffect()
        }
    )
}
