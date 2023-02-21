//
//  RemovePopupViewModifier.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

struct RemovePopupViewModifier: ViewModifier {
    // TODO: Store 추가 필요
    @Binding var isShowing: Bool

    func body(content: Content) -> some View {
        ZStack {
            content

            if isShowing {
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.black)
                    .opacity(0.5)
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                    }
                    .ignoresSafeArea()

                popup
                    .zIndex(1)
                    .animation(.easeInOut(duration: 0.2), value: isShowing)
                    .transition(.opacity)
            }
        }
    }

    private var popup: some View {
        ZStack(alignment: .center) {
            PopupView(
                title: "게시물이 삭제됩니다.",
                message: "정말 삭제하시겠습니까?",
                popupButtons: [
                    PopupButton(buttonText: "취소하기", buttonCompletionHandler: {
                        isShowing = false
                    }, type: .cancel),
                    PopupButton(buttonText: "삭제하기", buttonCompletionHandler: {
                        isShowing = false
                    }, type: .destructive)
                ])
        }
    }
}

struct RemovePopupViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World!")
            .modifier(RemovePopupViewModifier(isShowing: .constant(true)))
    }
}
