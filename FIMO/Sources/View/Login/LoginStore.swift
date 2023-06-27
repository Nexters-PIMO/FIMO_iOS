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
        @BindingState var isShowToast: Bool = false
        var toastMessage: ToastModel = ToastModel(title: FIMOStrings.textCopyToastTitle,
                                                  message: FIMOStrings.textCopyToastMessage)
        var isSignIn = false
        var errorMessage = ""
        var userIdentity = ""
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case sendToast(ToastModel)
        case sendToastDone
        case tappedKakaoLoginButton(String)
        case tappedAppleLoginButton(String)
        case enterProfileSetting(String)
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
            case let .sendToast(toastModel):
                if state.isShowToast {
                    return EffectTask<Action>(value: .sendToast(toastModel))
                        .delay(for: .milliseconds(1000), scheduler: DispatchQueue.main)
                        .eraseToEffect()
                } else {
                    state.isShowToast = true
                    state.toastMessage = toastModel
                    return EffectTask<Action>(value: .sendToastDone)
                        .delay(for: .milliseconds(2000), scheduler: DispatchQueue.main)
                        .eraseToEffect()
                }
            case .sendToastDone:
                state.isShowToast = false
            case .tappedAppleLoginButton(let userIdentity):
                guard userIdentity != "" else {
                    return .init(value: .sendToast(ToastModel(title: "U")))
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
            case .loginAgain:
                let loginResult = loginClient.login(state.userIdentity)

                return loginResult.map {
                    Action.loginResult($0)
                }
            case .failureLogin(let error):
                switch error.errorType {
                case .serverError(.userNotFound):
                    Log.warning("유저 정보가 없으므로 프로필 기입 화면으로 이동합니다!!!")
                    return .init(value: .enterProfileSetting(state.userIdentity))
                default:
                    return .init(value: .sendToast(ToastModel(title: error.errorDescription ?? "")))
                }
            default:
                return .none
            }
            return .none
        }
    }
}
