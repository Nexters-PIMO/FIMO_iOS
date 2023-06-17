//
//  ModifyProfileBackPopup.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/03/29.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

extension View {
    func modifyProfileBackPopup(isShowing: Binding<Bool>, store: ViewStore<TabBarStore.State, TabBarStore.Action>) -> some View {
        return self.modifier(ModifyProfileBackPopupViewModifier(isShowing: isShowing, store: store))
    }
}

struct ModifyProfileBackPopupViewModifier: ViewModifier {
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
                title: "수정한 내용이 저장되지 않습니다",
                message: "정말 나가시겠습니까?",
                popupButtons: [
                    PopupButton(buttonText: "취소하기", buttonCompletionHandler: {
                        isShowing = false
                    }, type: .cancel),
                    PopupButton(buttonText: "나가기", buttonCompletionHandler: {
                        store.send(.acceptBackOnProfileSetting)
                        isShowing = false
                    }, type: .destructive)
                ])
        }
    }
}
