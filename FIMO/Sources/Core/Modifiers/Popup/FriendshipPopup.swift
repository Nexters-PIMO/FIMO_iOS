//
//  FriendshipPopup.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/26.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Kingfisher

extension View {
    func friendshipPopup(
        isShowing: Binding<Bool>,
        store: ViewStore<TabBarStore.State, TabBarStore.Action>,
        selectedFriend: FMFriend
    ) -> some View {
        return self.modifier(
            FriendshipPopupViewModifier(
                isShowing: isShowing,
                store: store,
                selectedFriend: selectedFriend
            )
        )
    }
}

struct FriendshipPopupViewModifier: ViewModifier {
    @Binding var isShowing: Bool
    let store: ViewStore<TabBarStore.State, TabBarStore.Action>
    let selectedFriend: FMFriend
    var selectedFriendImage: KFImage {
        return KFImage(URL(string: selectedFriend.profileImageUrl))
            .placeholder {
                Rectangle()
                    .foregroundColor(.gray)
            }
    }

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
                image: selectedFriendImage,
                title: selectedFriend.archiveName,
                message: selectedFriend.nickname,
                popupButtons: [
                    PopupButton(buttonText: "취소하기", buttonCompletionHandler: {
                        isShowing = false
                    }, type: .cancel),
                    PopupButton(buttonText: selectedFriend.friendType.friendshipInteraction.okButtonDescription, buttonCompletionHandler: {
                        store.send(.acceptFriendship(selectedFriend))
                        isShowing = false
                    }, type: .destructive)
                ])
        }
    }
}
