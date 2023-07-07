//
//  RemovePopup.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

extension View {
    func removePopup(isShowing: Binding<Bool>, store: ViewStore<TabBarStore.State, TabBarStore.Action>) -> some View {
        return self.modifier(RemovePopupViewModifier(isShowing: isShowing, store: store))
    }
}

struct RemovePopupViewModifier: ViewModifier {
    @Binding var isShowing: Bool
    let store: ViewStore<TabBarStore.State, TabBarStore.Action>

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
                        store.send(.deletePost)
                    }, type: .destructive)
                ])
        }
    }
}
