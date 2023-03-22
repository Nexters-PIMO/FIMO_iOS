//
//  LoginService.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Combine
import Foundation

import ComposableArchitecture

struct LoginClient {
    let appleLogin: (Int) -> EffectPublisher<AppleLogin, NetworkError>
}

extension DependencyValues {
    var loginClient: LoginClient {
        get { self[LoginClient.self] }
        set { self[LoginClient.self] = newValue }
    }
}

extension LoginClient: DependencyKey {
    static let liveValue = Self.init { identityToken in
        let request = AppleLoginRequest(parameters: [
            "identityToken": identityToken
        ])

        return BaseNetwork.shared.request(api: request, isInterceptive: false)
            .eraseToEffect()
    }
}
