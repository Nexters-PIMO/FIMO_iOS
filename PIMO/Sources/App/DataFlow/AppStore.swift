//
//  AppStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/26.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct AppStore: ReducerProtocol {
    struct State: Equatable {
        var homeState = HomeStore.State()
        var loginState = LoginStore.State()
        var appDelegateState = AppDelegateStore.State()
        var userState = UserStore.State()
    }

    enum Action: Equatable {
        case login(LoginStore.Action)
        case home(HomeStore.Action)
        case appDelegate(AppDelegateStore.Action)
        case user(UserStore.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { _, action in
            switch action {
            case .appDelegate(.onLaunchFinish):
                return .init(value: .user(.checkAccessToken))
            default:
                return .none
            }
        }

        Scope(state: \.appDelegateState, action: /Action.appDelegate) {
          AppDelegateStore()
        }

        Scope(state: \.userState, action: /Action.user) {
          UserStore()
        }

        Scope(state: \.homeState, action: /Action.home) {
          HomeStore()
        }

        Scope(state: \.loginState, action: /Action.login) {
          LoginStore()
        }
    }
}
