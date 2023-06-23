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
        case resetPageIndex
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
                return .init(value: .resetPageIndex)
                    .delay(for: .milliseconds(1000), scheduler: DispatchQueue.main)
                    .eraseToEffect()
            case .login(.enterProfileSetting(let userId)):
                state.profileSettingState.userId = userId
                state.path.append(.nickName)
                return .none
            case .profileSetting(.tappedNextButtonOnNickname):
                state.path.append(.archiveName)
                return .none
            case .profileSetting(.tappedNextButtonOnArchive):
                state.path.append(.profilePicture)
                return .none
            case .resetPageIndex:
                state.onboardingState.pageType = .one
                return .none
            case .profileSetting(.signUpDone(let result)):
                switch result {
                case .success(let serverDescription):
                    switch serverDescription.status {
                    case 200:
                        return .init(value: .login(.loginAgain))
                    case 409:
                        state.path.removeAll(where: { $0 == .profilePicture || $0 == .archiveName  })
                    default:
                        break
                    }
                    return .none
                case .failure:
                    state.path.removeAll(where: { $0 == .profilePicture || $0 == .archiveName  })
                    return .none
                }
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
