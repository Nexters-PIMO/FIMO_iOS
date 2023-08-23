//
//  AppDelegate.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/26.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import FirebaseCore
import FirebaseDynamicLinks
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
        
        FirebaseApp.configure()
        
        return true
    }
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        
        return sceneConfig
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let handled = DynamicLinks.dynamicLinks()
            .handleUniversalLink(userActivity.webpageURL!) { dynamiclink, error in }
        
        return handled
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: ""
        )
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?,
                     annotation: Any) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            return true
        }
        
        return false
    }
}
