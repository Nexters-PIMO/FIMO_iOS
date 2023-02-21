//
//  SceneDelegate.swift
//  PIMO
//
//  Created by 양호준 on 2023/02/11.
//  Copyright © 2023 pimo. All rights reserved.
//

import UIKit

class SceneDelegate: NSObject, ObservableObject, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = windowScene.keyWindow
    }
}
