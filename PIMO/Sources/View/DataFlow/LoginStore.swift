//
//  LoginStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import ComposableArchitecture
import KakaoSDKUser

struct LoginStore: ReducerProtocol {
    struct State: Equatable { }
    
    enum Action: Equatable {
        case tappedKakaoLoginButton
        case tappedAppleLoginButton
    }
    
    @Dependency(\.loginClient) var loginClient
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .tappedAppleLoginButton:
                print("HOHOHOHOHO")
                return .none
            case .tappedKakaoLoginButton:
                if UserApi.isKakaoTalkLoginAvailable() {
                    UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            print("loginWithKakaoTalk() success.")

                            //do something
                            _ = oauthToken
                        }
                    }
                } else {
                    UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                            if let error = error {
                                print(error)
                            }
                            else {
                                print("loginWithKakaoAccount() success.")

                                //do something
                                _ = oauthToken
                            }
                        }
                }
                
                return .none
            }
        }
    }
}
