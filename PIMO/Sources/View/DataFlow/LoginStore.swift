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
    let loginClient: LoginClient
}

let loginReducer = AnyReducer<LoginState, LoginAction, LoginEnvironment> { _, action, _ in
    switch action {
    case .tappedKakaoLoginButton:
        return .none
    case .tappedAppleLoginButton:
        return .none
    }
}
