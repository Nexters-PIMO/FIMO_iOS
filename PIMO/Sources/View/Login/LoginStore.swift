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
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case tappedKakaoLoginButton(String)
        case tappedAppleLoginButton(String)
        case onSuccessLogin(Bool)
        case showAlert
        case tappedAlertOKButton
        case tappedAppleLoginButtonDone(Result<AppleLogin, NetworkError>)
        case encodeTokenDone(Result<EncodeLogin, NetworkError>)
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
                    guard let accessToken = appleLogin.data?.accessToken else {
                        return .none
                    }

                    return loginClient.encodeAppleLoginToken(accessToken).map { Action.encodeTokenDone($0) }
                case .failure:
                    return .init(value: Action.showAlert)
                }
            case .tappedKakaoLoginButton(let token):
                return loginClient.encodeKakaoLoginToken(token).map { Action.encodeTokenDone($0) }
            case .encodeTokenDone(let result):
                switch result {
                case .success(let encodeLogin):
                    guard let encodedAccessToken = encodeLogin.data?.accessToken else {
                        return .none
                    }

                    let memberToken = MemberToken(accessToken: encodedAccessToken, refreshToken: nil)
                    UserUtill.shared.setUserDefaults(key: .token, value: memberToken)

                    // TODO: - 메인 탭바로 연결해줘야 함.
                case .failure:
                    return .init(value: Action.showAlert)
                }
                
                return .none
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
