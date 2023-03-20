//
//  PopupView.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

struct PopupView: View {
    private var image: Image?
    private var title: String
    private var message: String
    private var popupButtons: [PopupButton]

    init(image: Image? = nil, title: String, message: String, popupButtons: [PopupButton]) {
        self.image = image
        self.title = title
        self.message = message
        self.popupButtons = popupButtons
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            ZStack {
                Color.white
                VStack(alignment: .leading, spacing: 0) {
                    VStack(spacing: image == nil ? 10 : 12) {
                        image?
                            .resizable()
                            .frame(width: 56, height: 56)
                            .mask({
                                Circle()
                            })

                        Text(title)
                            .font(.system(size: 18, weight: .semibold))
                        Text(message)
                            .font(.system(size: 14))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, image == nil ? 42 : 24)

                    Spacer()

                    HStack(spacing: 0) {
                        ForEach(popupButtons.indices, id: \.self) { index in
                            popupButtons[index]
                                .border(width: 1,
                                        edges: index == 0 ? [.top] : [.top, .leading],
                                        color: Color(PIMOAsset.Assets.grayLine.color))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(width: 300, height: image == nil ? 180 : 220)
            .cornerRadius(2)
        }
    }
}

struct PopupButton: View {
    let buttonText: String
    let buttonCompletionHandler: (() -> Void)?
    let type: PopupButtonType

    var body: some View {
        Button {
            buttonCompletionHandler?()
        } label: {
            Text(buttonText)
        }
        .frame(maxWidth: .infinity, minHeight: 56)
        .foregroundColor(type.color)
    }
}

struct PopupView_Previews: PreviewProvider {
    static var previews: some View {
        PopupView(
            title: "Hello",
            message: "World!",
            popupButtons: [
                PopupButton(
                    buttonText: "Cancel",
                    buttonCompletionHandler: nil,
                    type: .cancel
                ),
                PopupButton(
                    buttonText: "OK",
                    buttonCompletionHandler: nil,
                    type: .destructive
                )
            ]
        )
    }
}
