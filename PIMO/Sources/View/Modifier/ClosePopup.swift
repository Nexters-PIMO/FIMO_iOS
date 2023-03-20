//
//  ClosePopup.swift
//  PIMO
//
//  Created by 양호준 on 2023/02/25.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

extension View {
    func closePopup(isShowing: Binding<Bool>) -> some View {
        return self.modifier(RemovePopupViewModifier(isShowing: isShowing))
    }
}

struct ClosePopupViewModifier: ViewModifier {
    var viewStore: ViewStore<UploadStore.State, UploadStore.Action>
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
                title: "작성중인 게시물이 삭제됩니다.",
                message: "정말 나가시겠어요?",
                popupButtons: [
                    PopupButton(buttonText: "취소하기", buttonCompletionHandler: {
                        isShowing = false
                    }, type: .cancel),
                    PopupButton(buttonText: "나가기", buttonCompletionHandler: {
                        isShowing = false
                        viewStore.send(.didTapCloseButton)
                    }, type: .destructive)
                ])
        }
    }
}
