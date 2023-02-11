//
//  LoginStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import AuthenticationServices
import Foundation

import ComposableArchitecture
import KakaoSDKUser

struct LoginStore: ReducerProtocol {
    struct State: Equatable {
        var isSignIn = false
        var errorMessage = ""
    }
    
    enum Action: Equatable {
        case tappedKakaoLoginButton
        case tappedAppleLoginButton
    }
    
    @Dependency(\.loginClient) var loginClient
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .tappedAppleLoginButton:
                return .none
            case .tappedKakaoLoginButton:
                var errorMessage = ""
                var isSignIn = false
                
                if UserApi.isKakaoTalkLoginAvailable() {
                    UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                        if let error {
                            errorMessage = error.localizedDescription
                        } else {
                            isSignIn = true

                            UserUtill.shared.setUserDefaults(key: .token, value: oauthToken?.accessToken)
                        }
                    }
                } else {
                    UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                        if let error = error {
                            errorMessage = error.localizedDescription
                        } else {
                            isSignIn = true

                            UserUtill.shared.setUserDefaults(key: .token, value: oauthToken?.accessToken)
                        }
                    }
                }
                
                state.errorMessage = errorMessage
                state.isSignIn = isSignIn
                
                return .none
            }
        }
    }
}
