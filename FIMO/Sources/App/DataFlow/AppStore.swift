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
        var unAuthenticatedStore = UnAuthenticatedStore.State()
        var tabBarState = TabBarStore.State()
        var appDelegateState = AppDelegateStore.State()
        var userState = UserStore.State()
        var isLoading: Bool = true
    }

    enum Action: Equatable {
        case unAuthenticated(UnAuthenticatedStore.Action)
        case tabBar(TabBarStore.Action)
        case appDelegate(AppDelegateStore.Action)
        case user(UserStore.Action)
        case onAppear
        case hiddenLaunchScreen
        case withdrawal
        case withdrawalDone(Result<FMServerDescriptionDTO, NetworkError>)
    }

    @Dependency(\.loginClient) var loginClient

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .appDelegate(.onLaunchFinish):
                return .init(value: .user(.checkAccessToken))
            case .onAppear:
                return .init(value: .hiddenLaunchScreen)
                    .delay(for: .milliseconds(2000), scheduler: DispatchQueue.main)
                    .eraseToEffect()
            case .hiddenLaunchScreen:
                state.isLoading = false
                return .none
            case .user(let action):
                switch action {
                case .changeUnAuthenticated:
                    state.userState.status = .unAuthenticated
                    state.tabBarState = TabBarStore.State()
                case .changeAuthenticated:
                    state.userState.status = .authenticated
                    state.unAuthenticatedStore = UnAuthenticatedStore.State()
                default:
                    break
                }
            case .unAuthenticated(let action):
                switch action {
                case .profileSetting(.tappedCompleteButton):
                    return .init(value: .user(.changeAuthenticated))
                case .login(.loginResult(let result)):
                    switch result {
                    case .success(let memberToken):
                        var effects: [EffectTask<AppStore.Action>] = [
                            .init(value: .user(.setToken))
                        ]
                        if state.unAuthenticatedStore.profileSettingState.userId != "" {
                            state.userState.token = memberToken
                            state.unAuthenticatedStore.path.append(.complete)
                        } else {
                            state.userState.token = memberToken
                            state.userState.status = .authenticated
                            effects.append(.init(value: .user(.changeAuthenticated)))
                        }
                        return .merge(effects)
                    case .failure(let error):
                        return .init(value: Action.unAuthenticated(.login(.failureLogin(error))))
                    }
                default:
                    return .none
                }
            case .tabBar(.acceptLogout):
                let effects: [EffectTask<AppStore.Action>] = [
                    .init(value: .user(.expiredToken)),
                    .init(value: .user(.changeUnAuthenticated))
                ]
                return .merge(effects)
            case .tabBar(.acceptWithdrawal):
                let withdrawalResult = loginClient.withdrawal()

                return withdrawalResult.map({
                    Action.withdrawalDone($0)
                })
            case .withdrawalDone(let result):
                switch result {
                case .success:
                    return .init(value: .withdrawal)
                case .failure:
                    return .none
                }
            case .withdrawal:
                let effects: [EffectTask<AppStore.Action>] = [
                    .init(value: .user(.expiredToken)),
                    .init(value: .user(.changeUnAuthenticated))
                ]
                return .merge(effects)
            default:
                break
            }
            return .none
        }

        Scope(state: \.appDelegateState, action: /Action.appDelegate) {
            AppDelegateStore()
        }

        Scope(state: \.userState, action: /Action.user) {
            UserStore()
        }

        Scope(state: \.tabBarState, action: /Action.tabBar) {
            TabBarStore()
        }

        Scope(state: \.unAuthenticatedStore, action: /Action.unAuthenticated) {
            UnAuthenticatedStore()
        }
    }
}
