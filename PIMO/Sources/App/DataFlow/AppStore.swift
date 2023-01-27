//
//  AppStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/26.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct AppState: Equatable {
    var homeState = HomeState()
    var loginState = LoginState()
    var appDelegateState = AppDelegateState()
    var userState = UserState()
}

enum AppAction: Equatable {
    case login(LoginAction)
    case home(HomeAction)
    case appDelegate(AppDelegateAction)
    case user(UserAction)
}

struct AppEnvironment {
    let homeClient: HomeClient
    let loginClient: LoginClient
    let userClient: UserClient
}

let appReducerCore = AnyReducer<AppState, AppAction, AppEnvironment> { _, action, _ in
    switch action {
    case .appDelegate(.onLaunchFinish):
        return .init(value: .user(.checkAccessToken))
    default:
        return .none
    }
}

let appReducer = AnyReducer<AppState, AppAction, AppEnvironment>.combine([
    appReducerCore,
    appDelegateReducer.pullback(
        state: \AppState.appDelegateState,
        action: /AppAction.appDelegate,
        environment: {
            .init(userClient: $0.userClient)
        }),
    homeReducer.pullback(
        state: \AppState.homeState,
        action: /AppAction.home,
        environment: {
            .init(homeClient: $0.homeClient)
        }),
    loginReducer.pullback(
        state: \AppState.loginState,
        action: /AppAction.login,
        environment: {
            .init(loginClient: $0.loginClient)
        }),
    userReducer.pullback(
        state: \AppState.userState,
        action: /AppAction.user,
        environment: {
            .init(userClient: $0.userClient)
        })
])
