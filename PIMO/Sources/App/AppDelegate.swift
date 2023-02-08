//
//  AppDelegate.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/26.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import KakaoSDKAuth

class AppDelegate: UIResponder, UIApplicationDelegate {
    let store = Store<AppStore.State, AppStore.Action>(
        initialState: AppStore.State(),
        reducer: AppStore()
    )

    lazy var viewStore = ViewStore<AppStore.State, AppStore.Action>(store)

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        viewStore.send(.appDelegate(.onLaunchFinish))

        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }

        return false
    }
}
