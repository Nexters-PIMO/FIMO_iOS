import SwiftUI

import ComposableArchitecture
import KakaoSDKAuth
import KakaoSDKCommon

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
                    TabBarView(
                        store: appDelegate.store.scope(
                            state: \.tabBarState,
                            action: AppStore.Action.tabBar
                        )
                    )
//                    OnboardingView(
//                        store: appDelegate.store.scope(
//                            state: \.onboardingState,
//                            action: AppStore.Action.onboarding
//                        )
//                    )
//                    .onOpenURL { url in
//                        if AuthApi.isKakaoTalkLoginUrl(url) {
//                            AuthController.handleOpenUrl(url: url)
//                        }
//                    }
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
    
    init() {
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String
        
        KakaoSDK.initSDK(appKey: kakaoAppKey ?? "")
    }
}
