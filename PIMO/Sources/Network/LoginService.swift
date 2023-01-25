//
//  LoginService.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Combine

protocol LoginServiceInterface {
    func appleLogin(identityToken: String) -> AnyPublisher<AppleLogin, Error>
}

struct LoginService: LoginServiceInterface {
    private let network: BaseNetwork

    init(baseNetwork: BaseNetwork = BaseNetworkImpl()) {
        self.network = baseNetwork
    }

    func appleLogin(identityToken: String) -> AnyPublisher<AppleLogin, Error> {
        let request = AppleLoginRequest(parameters: [
            "identityToken": identityToken
        ])

        return network.request(api: request, isInterceptive: false)
            .eraseToAnyPublisher()
    }
}
