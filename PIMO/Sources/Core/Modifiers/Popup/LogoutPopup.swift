//
//  LogoutPopup.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/27.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

extension View {
    func logoutPopup(isShowing: Binding<Bool>, store: ViewStore<TabBarStore.State, TabBarStore.Action>) -> some View {
        return self.modifier(LogoutPopupViewModifier(isShowing: isShowing, store: store))
    }
}

struct LogoutPopupViewModifier: ViewModifier {
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
                title: "로그아웃",
                message: "정말 로그아웃하시겠습니까?",
                popupButtons: [
                    PopupButton(buttonText: "취소하기", buttonCompletionHandler: {
                        isShowing = false
                    }, type: .cancel),
                    PopupButton(buttonText: "로그아웃", buttonCompletionHandler: {
                        store.send(.acceptLogout)
                        isShowing = false
                    }, type: .destructive)
                ])
        }
    }
}
