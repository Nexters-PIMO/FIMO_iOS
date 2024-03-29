//
//  KakaoLoginButton.swift
//  PIMO
//
//  Created by 양호준 on 2023/03/17.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI
import UIKit

import ComposableArchitecture
import KakaoSDKUser

struct KakaoLoginButton: UIViewRepresentable {
    let viewStore: ViewStore<LoginStore.State, LoginStore.Action>
    let action: (String) -> Void

    var kakaoLoginButton = UIButton()

    func makeCoordinator() -> Coordinator { Coordinator(self, viewStore: viewStore) }

    class Coordinator: NSObject {
        var kakaoLoginButton: KakaoLoginButton
        let viewStore: ViewStore<LoginStore.State, LoginStore.Action>

        init(_ kakaoLoginButton: KakaoLoginButton, viewStore: ViewStore<LoginStore.State, LoginStore.Action>) {
            self.kakaoLoginButton = kakaoLoginButton
            self.viewStore = viewStore

            super.init()
        }

        @objc func doAction(_ sender: Any) {
            requestKakaoLogin()
        }

        private func requestKakaoLogin() {
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { [weak self] (_, error) in
                    guard let self else {
                        return
                    }

                    if error != nil {
                        self.kakaoLoginButton.viewStore.send(.sendToast(ToastModel(title: error?.localizedDescription ?? "")))
                    } else {
                        self.requestUserInfo()
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { [weak self] (_, error) in
                    guard let self else {
                        return
                    }

                    if error != nil {
                        self.kakaoLoginButton.viewStore.send(.sendToast(ToastModel(title: error?.localizedDescription ?? "")))
                    } else {
                        self.requestUserInfo()
                    }
                }
            }
        }

        private func requestUserInfo() {
            UserApi.shared.me { [weak self] (user, error) in
                guard let self else {
                    return
                }

                if let error = error {
                    self.kakaoLoginButton.viewStore.send(.sendToast(ToastModel(title: error.localizedDescription)))
                } else {
                    let id = String(Int(user?.id ?? 0))
                    self.kakaoLoginButton.action(id)
                }
            }
        }
    }

    func makeUIView(context: Context) -> UIButton {
        let button = UIButton()

        button.setImage(
            FIMOAsset.Assets.kakaoLoginLargeWide.image.withRenderingMode(.alwaysOriginal),
            for: .normal
        )
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill

        button.addTarget(context.coordinator, action: #selector(Coordinator.doAction(_ :)), for: .touchDown)

        return button
    }

    func updateUIView(_ uiView: UIButton, context: Context) { }
}
