//
//  SettingStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/25.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct SettingStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var isShowBackPopup: Bool = false
        @BindingState var isSheetPresented: Bool = false
        @BindingState var isShowToast: Bool = false
        var toastMessage: ToastModel = ToastModel(title: FIMOStrings.textCopyToastTitle,
                                                  message: FIMOStrings.textCopyToastMessage)
        var onboarding: OnboardingStore.State?
        var profile: FMProfile = .EMPTY
        var termsOfUseURL: URL? = URL(string: FIMOStrings.termsOfUseURL)

        var version: String {
            guard let dictionary = Bundle.main.infoDictionary,
                  let version = dictionary["CFBundleShortVersionString"] as? String else {
                return ""
            }

            return version
        }
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case sendToast(ToastModel)
        case sendToastDone
        case onboarding(OnboardingStore.Action)
        case tappedProfileManagementButton
        case tappedGuideAgainButton
        case tappedLicenceButton
        case tappedTermsOfUseButton
        case tappedLogoutButton
        case tappedWithdrawalButton
        case acceptBack
    }

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
            case .tappedTermsOfUseButton:
                return .none
            case .tappedGuideAgainButton:
                state.onboarding = OnboardingStore.State(isAgainGuideReview: true)
                state.isSheetPresented = true
                return .none
            case .onboarding(.startButtonTapped), .onboarding(.skipButtonTapped):
                state.isSheetPresented = false
                return .none
            default:
                return .none
            }
            return .none
        }
        .ifLet(\.onboarding, action: /Action.onboarding) {
            OnboardingStore()
        }
    }
}
