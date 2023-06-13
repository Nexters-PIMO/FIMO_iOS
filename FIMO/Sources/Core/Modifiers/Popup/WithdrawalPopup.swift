//
//  WithdrawalPopup.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/27.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

extension View {
    func withdrawalPopup(isShowing: Binding<Bool>, store: ViewStore<SettingStore.State, SettingStore.Action>) -> some View {
        return self.modifier(WithdrawalViewModifier(isShowing: isShowing, store: store))
    }
}

struct WithdrawalViewModifier: ViewModifier {
    @Binding var isShowing: Bool
    let store: ViewStore<SettingStore.State, SettingStore.Action>

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
                title: "정말 탈퇴하시겠습니까?",
                message: "회원탈퇴 시 아카이브에 저장된\n글사진이 모두 사라집니다.",
                popupButtons: [
                    PopupButton(buttonText: "탈퇴하기", buttonCompletionHandler: {
                        isShowing = false
                        store.send(.acceptWithdrawal)
                    }, type: .cancel),
                    PopupButton(buttonText: "취소하기", buttonCompletionHandler: {
                        isShowing = false
                    }, type: .destructive)
                ])
        }
    }
}
