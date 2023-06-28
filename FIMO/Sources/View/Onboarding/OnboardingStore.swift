//
//  OnboardingStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/03/08.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct OnboardingStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var pageType: OnboardingPageType = .one
        var isAgainGuideReview: Bool = false
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case startButtonTapped
        case skipButtonTapped
        case changePage(OnboardingPageType)
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .changePage(let pageType):
                state.pageType = pageType
                return .none
            default:
                return .none
            }
        }
    }
}
