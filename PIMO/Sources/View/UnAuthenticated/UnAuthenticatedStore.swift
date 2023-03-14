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
    @Environment(\.presentationMode) var presentation

    struct State: Equatable {
        @BindingState var path: [UnauthenticatedScene] = []
        var onboardingState = OnboardingStore.State()
        var loginState = LoginStore.State()
        var profileSettingState = ProfileSettingStore.State()
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case login(LoginStore.Action)
        case profileSetting(ProfileSettingStore.Action)
        case onboarding(OnboardingStore.Action)
        case transitionSceneOnOnboarding
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onboarding(.startButtonTapped):
                return .send(.transitionSceneOnOnboarding)
            case .onboarding(.skipButtonTapped):
                return .send(.transitionSceneOnOnboarding)
            case .transitionSceneOnOnboarding:
                state.path.append(.login)
                state.onboardingState.pageType = .one
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

        Scope(state: \.onboardingState, action: /Action.onboarding) {
            OnboardingStore()
        }

        Scope(state: \.loginState, action: /Action.login) {
            LoginStore()
        }

        Scope(state: \.profileSettingState, action: /Action.profileSetting) {
            ProfileSettingStore()
        }
    }
}
