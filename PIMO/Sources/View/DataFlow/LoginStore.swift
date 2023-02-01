//
//  LoginStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import ComposableArchitecture

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
            case .tappedAppleLoginButton, .tappedKakaoLoginButton:
                print("HOHOHOHOHO")
                return .none
            }
        }
    }
}
