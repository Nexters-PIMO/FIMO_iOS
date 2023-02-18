import SwiftUI

import ComposableArchitecture

@main
struct PIMOApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            WithViewStore(
                appDelegate.store.scope(state: \.userState.status)
            ) { viewStore in
                switch viewStore.state {
                case .unAuthenticated:
                    OnboardingView(
                        store: appDelegate.store.scope(
                            state: \.onboardingState,
                            action: AppStore.Action.onboarding
                        )
                    )
                case .authenticated:
                    TabBarView(
                        store: appDelegate.store.scope(
                            state: \.tabBarState,
                            action: AppStore.Action.tabBar
                        )
                    )
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .tokenExpired)) { _ in
                #warning("TCA 맞춰 재로그인 구현 필요")
            }
        }
    }
}
