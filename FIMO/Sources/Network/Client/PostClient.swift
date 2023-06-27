//
//  PostClient.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/27.
//  Copyright © 2023 pimo. All rights reserved.
//

import Combine
import Foundation

import ComposableArchitecture

struct PostClient {
    let uploadPost: (FMUpdatedPost) -> EffectPublisher<Result<FMPostDTO, NetworkError>, Never>
}

extension DependencyValues {
    var postClient: PostClient {
        get { self[PostClient.self] }
        set { self[PostClient.self] = newValue }
    }
}

extension PostClient: DependencyKey {
    static let liveValue = Self.init { newPostItems in
        let request = FMCreatePostRequest(newPostItems: newPostItems)

        return BaseNetwork.shared.request(api: request, isInterceptive: true)
            .catchToEffect()
    }
}
