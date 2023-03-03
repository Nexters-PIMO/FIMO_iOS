//
//  Ununthenticated.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/03/03.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

enum UnauthenticatedScene: Hashable {
    case onboarding
    case login
    case nickName
    case archiveName
    case profilePicture
    case complete
}

struct UnAuthenticatedStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var path: [UnauthenticatedScene] = []
        @BindingState var pageType: OnboardingPageType = .one
        var loginState = LoginStore.State()
        var profileSettingState = ProfileSettingStore.State()
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case login(LoginStore.Action)
        case profileSetting(ProfileSettingStore.Action)
        case startButtonTapped
        case skipButtonTapped
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .startButtonTapped:
                state.path.append(.login)
                state.pageType = .one
                return .none
            case .skipButtonTapped:
                state.path.append(.login)
                state.pageType = .one
                return .none
            case .login(.onSuccessLogin(let onSuccess)):
                if onSuccess {
                    state.path.append(.nickName)
                }
                return .none
            case .profileSetting(.tappedNextButtonOnNickname):
                state.path.append(.archiveName)
                return .none
            case .profileSetting(.tappedNextButtonOnArchive):
                state.path.append(.profilePicture)
                return .none
            case .profileSetting(.tappedNextButtonOnProfilePicture):
                state.path.append(.complete)
                return .none
            default:
                return .none
            }
        }

        Scope(state: \.loginState, action: /Action.login) {
            LoginStore()
        }

        Scope(state: \.profileSettingState, action: /Action.profileSetting) {
            ProfileSettingStore()
        }
    }
}
