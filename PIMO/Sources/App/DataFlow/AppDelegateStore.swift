//
//  AppDelegateStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/26.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct AppDelegateState: Equatable { }

enum AppDelegateAction: Equatable {
    case onLaunchFinish
}

struct AppDelegateEnvironment { }

let appDelegateReducer = AnyReducer<AppDelegateState, AppDelegateAction, AppDelegateEnvironment>.combine([
    AnyReducer<AppDelegateState, AppDelegateAction, AppDelegateEnvironment> { _, action, _ in
        switch action {
        case .onLaunchFinish:
            return .none
        }
    }
])
