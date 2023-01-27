//
//  AppDelegate.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/26.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

class AppDelegate: UIResponder, UIApplicationDelegate {
    let store = Store<AppState, AppAction>(
        initialState: AppState(),
        reducer: appReducer,
        environment: AppEnvironment(
            homeClient: .live,
            loginClient: .live,
            userClient: .live
        )
    )

    lazy var viewStore = ViewStore<AppState, AppAction>(store)

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptionslaunchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        viewStore.send(.appDelegate(.onLaunchFinish))

        return true
    }
}
