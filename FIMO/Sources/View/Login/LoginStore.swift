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
        var kakaoRefreshToken = ""
        var userIdentity = ""
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case tappedKakaoLoginButton(String, String)
        case tappedAppleLoginButton(String)
        case enterProfileSetting
        case showAlert
        case tappedAlertOKButton
        case failureLogin(NetworkError)
        case signup
        case tappedAppleLoginButtonDone(Result<MemberToken, NetworkError>)
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
                
                let tokenResult = loginClient.login(userIdentity)

                return tokenResult.map {
                    Action.tappedAppleLoginButtonDone($0)
                }
            case let .tappedKakaoLoginButton(accessToken, refreshToken):
                state.kakaoRefreshToken = refreshToken
                return .none
            case .showAlert:
                state.isAlertShowing = true
                
                return .none
            case .tappedAlertOKButton:
                state.isAlertShowing = false
                
                return .none
            case .failureLogin(let error):
                switch error.errorType {
                case .serverError(.userNotFound):
                    print("➡️ 유저 정보가 없으므로 프로필 기입 화면으로 이동합니다!!!")
                    return .init(value: .enterProfileSetting)
                default:
                    return .init(value: .showAlert)
                }
                return .none
            default:
                return .none
            }
        }
    }
}
