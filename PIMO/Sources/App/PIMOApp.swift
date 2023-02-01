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
                    LoginView(
                        store: appDelegate.store.scope(
                            state: \.loginState,
                            action: AppStore.Action.login
                        )
                    )
                case .authenticated:
                    HomeView(
                        store: appDelegate.store.scope(
                            state: \.homeState,
                            action: AppStore.Action.home
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
