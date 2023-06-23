//
//  LoginStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import AuthenticationServices
import Combine
import Foundation

import ComposableArchitecture
import KakaoSDKUser

struct LoginStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var isAlertShowing = false
        var isSignIn = false
        var errorMessage = ""
        var userIdentity = ""
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case tappedKakaoLoginButton(String)
        case tappedAppleLoginButton(String)
        case enterProfileSetting(String)
        case showAlert
        case tappedAlertOKButton
        case failureLogin(NetworkError)
        case signup
        case loginAgain
        case loginResult(Result<MemberToken, NetworkError>)
    }
    
    @Dependency(\.loginClient) var loginClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .tappedAppleLoginButton(let userIdentity):
                guard userIdentity != "" else {
                    return .init(value: Action.showAlert)
                }
                state.userIdentity = userIdentity
                
                let loginResult = loginClient.login(userIdentity)

                return loginResult.map {
                    Action.loginResult($0)
                }
            case let .tappedKakaoLoginButton(id):
                state.userIdentity = id

                let loginResult = loginClient.login(id)

                return loginResult.map {
                    Action.loginResult($0)
                }
            case let .loginAgain:
                let loginResult = loginClient.login(state.userIdentity)

                return loginResult.map {
                    Action.loginResult($0)
                }
            case .showAlert:
                state.isAlertShowing = true
                
                return .none
            case .tappedAlertOKButton:
                state.isAlertShowing = false
                
                return .none
            case .failureLogin(let error):
                switch error.errorType {
                case .serverError(.userNotFound):
                    Log.warning("유저 정보가 없으므로 프로필 기입 화면으로 이동합니다!!!")
                    return .init(value: .enterProfileSetting(state.userIdentity))
                default:
                    return .init(value: .showAlert)
                }
            default:
                return .none
            }
        }
    }
}
