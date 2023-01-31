//
//  AppDelegateStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/26.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct AppDelegateStore: ReducerProtocol {
    struct State: Equatable { }

    enum Action: Equatable {
        case onLaunchFinish
    }

    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
        switch action {
        case .onLaunchFinish:
            return .none
        }
    }
}
