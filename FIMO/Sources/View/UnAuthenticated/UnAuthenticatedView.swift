//
//  UnAuthenticatedView.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/03/08.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct UnAuthenticatedView: View {
    let store: StoreOf<UnAuthenticatedStore>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack(path: viewStore.binding(\.$path)) {
                OnboardingView(
                    store: store.scope(
                        state: \.onboardingState,
                        action: { UnAuthenticatedStore.Action.onboarding($0) }
                    )
                )
                .navigationDestination(for: UnauthenticatedScene.self) { scene in
                    switch scene {
                    case .login:
                        LoginView(
                            store: store.scope(
                                state: \.loginState,
                                action: { UnAuthenticatedStore.Action.login($0) }
                            )
                        )
                    case .nickName:
                        NicknameSettingView(
                            store: store.scope(
                                state: \.profileSettingState,
                                action: { UnAuthenticatedStore.Action.profileSetting($0) }
                            )
                        )
                    case .archiveName:
                        ArchiveSettingView(
                            store: store.scope(
                                state: \.profileSettingState,
                                action: { UnAuthenticatedStore.Action.profileSetting($0) }
                            )
                        )
                    case .profilePicture:
                        ProfilePictureSettingView(
                            store: store.scope(
                                state: \.profileSettingState,
                                action: { UnAuthenticatedStore.Action.profileSetting($0) }
                            )
                        )
                    case .complete:
                        CompleteSettingView(
                            store: store.scope(
                                state: \.profileSettingState,
                                action: { UnAuthenticatedStore.Action.profileSetting($0) }
                            )
                        )
                    default:
                        EmptyView()
                    }
                }
            }
        }
    }
}

struct UnAuthenticatedView_Previews: PreviewProvider {
    static var previews: some View {
        UnAuthenticatedView(
            store: Store(
                initialState: UnAuthenticatedStore.State(),
                reducer: UnAuthenticatedStore()
            )
        )
    }
}
