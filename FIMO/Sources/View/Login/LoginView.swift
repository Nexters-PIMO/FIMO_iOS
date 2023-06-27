//
//  ContentView.swift
//  PIMO
//
//  Created by 김영인 on 2023/01/20.
//  Copyright © 2023 PIMO. All rights reserved.
//

import AuthenticationServices
import SwiftUI
import UIKit

import ComposableArchitecture

struct LoginView: View {
    @EnvironmentObject var sceneDelegate: SceneDelegate
    let store: StoreOf<LoginStore>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Image(uiImage: FIMOAsset.Assets.onboardingBackgroundOne.image)
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFill()
                    .frame(
                        width: sceneDelegate.window?.bounds.width,
                        height: sceneDelegate.window?.bounds.height
                    )
                
                VStack {
                    Spacer()
                    Text("글사진 아카이브 플랫폼")
                        .font(Font(FIMOFontFamily.Pretendard.regular.font(size: 15)))
                        .foregroundColor(.white)
                        .opacity(0.6)
                        .padding(.bottom, 17)
                    Image(uiImage: FIMOAsset.Assets.appLogo.image)
                        .renderingMode(.original)
                        .scaledToFit()
                        .frame(width: 200, height: 40)
                    Spacer()
                    Text("SNS 계정으로 간편 가입하기")
                        .font(Font(FIMOFontFamily.Pretendard.medium.font(size: 14)))
                        .foregroundColor(.white)
                        .padding(.top, 0)
                        .padding(.bottom, 18)
                    KakaoLoginButton(viewStore: viewStore) { id in
                        DispatchQueue.main.async {
                            viewStore.send(.tappedKakaoLoginButton(id))
                        }
                    }
                    .alert("로그인이 실패했습니다", isPresented: viewStore.binding(\.$isAlertShowing)) {
                        Button("확인", role: .cancel) {
                            viewStore.send(.tappedAlertOKButton)
                        }
                    }
                    .frame(height: 54)
                    .padding(.top, 0)
                    .padding(.bottom, 18)
                    .padding([.leading, .trailing], 16)
                        
                    AppleLoginButton(
                        viewStore: viewStore,
                        window: sceneDelegate.window!,
                        title: "Apple로 로그인",
                        action: { token in
                            DispatchQueue.main.async {
                                viewStore.send(.tappedAppleLoginButton(token))
                            }
                        })
                    .alert("로그인이 실패했습니다", isPresented: viewStore.$isAlertShowing) {
                        Button("확인", role: .cancel) {
                            viewStore.send(.tappedAlertOKButton)
                        }
                    }
                    .cornerRadius(8)
                    .frame(height: 54)
                    .padding(.top, 0)
                    .padding(.bottom, 50)
                    .padding([.leading, .trailing], 16)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            store: Store(
                initialState: LoginStore.State(),
                reducer: LoginStore()
            )
        )
    }
}
