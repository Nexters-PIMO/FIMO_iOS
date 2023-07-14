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
    let fetchProfile: () -> EffectPublisher<Result<Profile, NetworkError>, Never>
    let fetchArchiveFeeds: (String) -> EffectPublisher<Result<[FMPostDTO], NetworkError>, Never>
    let fetchFeed: (String) -> EffectPublisher<Result<FMPostDTO, NetworkError>, Never>
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
        }, fetchArchiveFeeds: { userId in
            let request = FMAllPostRequest(target: .archive(userId))
            
            return BaseNetwork.shared.request(api: request, isInterceptive: false)
                .catchToEffect()
        }, fetchFeed: { feedId in
            let request = FMPostDetailRequest(postId: feedId)
            
            return BaseNetwork.shared.request(api: request, isInterceptive: false)
                .catchToEffect()
        }
    )
}
