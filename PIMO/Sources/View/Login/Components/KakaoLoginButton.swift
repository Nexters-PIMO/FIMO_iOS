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
                UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                    guard let self else { return }

                    if error != nil {
                        self.kakaoLoginButton.viewStore.send(.showAlert)
                    } else {
                        self.kakaoLoginButton.action(oauthToken?.accessToken ?? "")
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                    guard let self else { return }

                    if error != nil {
                        self.kakaoLoginButton.viewStore.send(.showAlert)
                    } else {
                        self.kakaoLoginButton.action(oauthToken?.accessToken ?? "")
                    }
                }
            }
        }
    }

    func makeUIView(context: Context) -> UIButton {
        let button = UIButton()

        button.setImage(
            PIMOAsset.Assets.kakaoLoginLargeWide.image.withRenderingMode(.alwaysOriginal),
            for: .normal
        )
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill

        button.addTarget(context.coordinator, action: #selector(Coordinator.doAction(_ :)), for: .touchDown)

        return button
    }

    func updateUIView(_ uiView: UIButton, context: Context) { }
}
