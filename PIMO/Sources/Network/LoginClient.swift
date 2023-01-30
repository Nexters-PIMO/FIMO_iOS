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
    var appleLogin: @Sendable (_ identityToken: String) -> Effect<AppleLogin, Error>
}

extension LoginClient {
    static let live = Self { identityToken in
        let request = AppleLoginRequest(parameters: [
            "identityToken": identityToken
        ])

        return BaseNetwork.shared.request(api: request, isInterceptive: false)
            .eraseToEffect()
    }
}
