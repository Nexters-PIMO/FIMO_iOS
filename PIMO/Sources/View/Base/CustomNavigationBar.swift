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
    var trailingItemType: TrailingItemType = .none
    var isShadowed: Bool = false
    var backButtonAction: (() -> Void)?
    var screenWidth: CGFloat {
        sceneDelegate.window?.bounds.width ?? 0
    }

    var body: some View {
        ZStack(alignment: .center) {
            Color.white

            Text(title)
                .font(Font(PIMOFontFamily.Pretendard.medium.font(size: 18)))
                .frame(width: 150, height: 18)

            HStack {
                Button {
                    if backButtonAction == nil {
                        presentation.wrappedValue.dismiss()
                    } else {
                        backButtonAction?()
                    }

                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                        .bold()
                }
                .padding(.leading, 20)

                Spacer()

                trailingItemType.view
                    .padding(.trailing, 20)
            }
        }
        .frame(width: screenWidth, height: 64)
        .shadow(
            color: isShadowed ? Color(PIMOAsset.Assets.grayShadow.color).opacity(0.1) : .clear,
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
