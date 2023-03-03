//
//  CustomNavigationBar.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/03/03.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

struct CustomNavigationBar: View {
    @EnvironmentObject var sceneDelegate: SceneDelegate
    @Environment(\.presentationMode) var presentation
    let title: String
    var screenWidth: CGFloat {
        sceneDelegate.window?.bounds.width ?? 0
    }

    var body: some View {
        ZStack {
            Color.white
    
            HStack {
                Button {
                    presentation.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                        .bold()
                }
                .padding(.leading, 20)

                Text(title)
                    .font(Font(PIMOFontFamily.Pretendard.medium.font(size: 18)))
                    .frame(width: 69, height: 18)
                    .padding(.leading, (screenWidth - 69) / 2 - 44)

                Spacer()
            }
        }
        .frame(width: screenWidth, height: 64)
        .shadow(
            color: Color(PIMOAsset.Assets.grayShadow.color).opacity(0.1),
            radius: 3,
            x: 0,
            y: 3
        )
    }
}

struct CustomNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationBar(title: "설정")
    }
}
