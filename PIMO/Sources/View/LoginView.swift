//
//  ContentView.swift
//  PIMO
//
//  Created by 김영인 on 2023/01/20.
//  Copyright © 2023 PIMO. All rights reserved.
//

import AuthenticationServices
import SwiftUI

import ComposableArchitecture

struct LoginView: View {
    let store: StoreOf<LoginStore>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Color.blue.ignoresSafeArea() // TODO: 추후 이미지로 대체되야 함
                
                VStack {
                    Text("글사진 아카이브 플랫폼")
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                        .opacity(0.6)
                    Image("app_logo")
                        .renderingMode(.original)
                        .scaledToFit()
                        .frame(width: 200, height: 40, alignment: .center)
                    Text("SNS 계정으로 간편 가입하기")
                        .foregroundColor(.white)
                    Image("kakao_login_medium_wide")
                        .renderingMode(.original)
                        .scaledToFit()
                        .cornerRadius(8)
                        .frame(width: 360, height: 54, alignment: .center)
                        .onTapGesture {
                            viewStore.send(.tappedKakaoLoginButton)
                        }
                    AppleLoginButton()
                        .cornerRadius(8)
                        .frame(width: 360, height: 54, alignment: .center)
                        .onTapGesture {
                            viewStore.send(.tappedAppleLoginButton)
                        }

                }
            }
        }
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
