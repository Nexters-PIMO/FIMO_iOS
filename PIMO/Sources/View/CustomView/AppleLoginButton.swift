//
//  AppleLoginButton.swift
//  PIMO
//
//  Created by 양호준 on 2023/02/09.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

struct AppleLoginButton: View {
    var body: some View {
        ZStack {
            Color(uiColor: .black)
            HStack {
                Image("apple_logo_medium")
                    .renderingMode(.original)
                    .scaledToFit()
                    .padding(EdgeInsets(top: .zero, leading: 10, bottom: .zero, trailing: .zero))
                Text("Apple로 로그인")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .padding(60)
            }
            .ignoresSafeArea()
        }
        .frame(width: 360, height: 54, alignment: .center)
    }
}
