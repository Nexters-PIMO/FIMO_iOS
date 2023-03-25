//
//  ProfileClient.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/18.
//  Copyright © 2023 pimo. All rights reserved.
//

import Combine
import Foundation

import ComposableArchitecture

struct ProfileClient {
    let fetchMyProfile: () -> EffectTask<Result<Profile, NetworkError>>
}

extension DependencyValues {
    var profileClient: ProfileClient {
        get { self[ProfileClient.self] }
        set { self[ProfileClient.self] = newValue }
    }
}

extension ProfileClient: DependencyKey {
    static let liveValue = Self.init {
        let request = ProfileRequest(target: .fetchMyProfile)

        return BaseNetwork.shared.request(api: request, isInterceptive: false)
            .catchToEffect()
    }
}
