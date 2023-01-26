//
//  LoginStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import ComposableArchitecture

struct LoginState: Equatable { }

enum LoginAction: Equatable {
    case tappedKakaoLoginButton
    case tappedAppleLoginButton
}

struct LoginEnvironment {
    let loginService: LoginServiceInterface
}

let LoginReducer = AnyReducer<LoginState, LoginAction, LoginEnvironment> { state, action, environment in
    switch action {
    case .tappedKakaoLoginButton:
        return .none
    case .tappedAppleLoginButton:
        return .none
    }
}
