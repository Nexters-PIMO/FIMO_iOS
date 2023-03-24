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
        var appleIdentityToken = ""
        var kakaoRefreshToken = ""
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case tappedKakaoLoginButton(String, String)
        case tappedAppleLoginButton(String)
        case onSuccessLogin(Bool)
        case showAlert
        case tappedAlertOKButton
        case tappedAppleLoginButtonDone(Result<AppleToken, NetworkError>)
        case encodeTokenDone(Result<EncodedToken, NetworkError>)
    }
    
    @Dependency(\.loginClient) var loginClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .tappedAppleLoginButton(let token):
                guard token != "" else {
                    return .none
                }
                
                state.appleIdentityToken = token
                
                let tokenResult = loginClient.getAppleLoginToken(token)

                return tokenResult.map {
                    Action.tappedAppleLoginButtonDone($0)
                }
            case .tappedAppleLoginButtonDone(let result):
                switch result {
                case .success(let appleLogin):
                    let accessToken = appleLogin.accessToken
                    
                    return loginClient.encodeAppleLoginToken(accessToken).map { Action.encodeTokenDone($0) }
                case .failure:
                    return .init(value: Action.showAlert)
                }
            case let .tappedKakaoLoginButton(accessToken, refreshToken):
                state.kakaoRefreshToken = refreshToken
                return loginClient.encodeKakaoLoginToken(accessToken).map { Action.encodeTokenDone($0) }
            case .encodeTokenDone(let result):
                switch result {
                case .success(let encodedToken):
                    let encodedAccessToken = encodedToken.accessToken

                    let memberToken = MemberToken(accessToken: encodedAccessToken, refreshToken: state.kakaoRefreshToken)
                    UserUtill.shared.setUserDefaults(key: .token, value: memberToken)

                    return .init(value: Action.onSuccessLogin(true))
                case .failure:
                    return .init(value: Action.showAlert)
                }
            case .showAlert:
                state.isAlertShowing = true
                
                return .none
            case .tappedAlertOKButton:
                state.isAlertShowing = false
                
                return .none
            default:
                return .none
            }
        }
    }
}
