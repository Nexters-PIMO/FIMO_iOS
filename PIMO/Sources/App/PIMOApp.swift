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
                appDelegate.store
            ) { viewStore in
                ZStack {
                    switch viewStore.state.userState.status {
                    case .unAuthenticated:
                        UnAuthenticatedView(
                            store:
                                appDelegate.store.scope(
                                    state: \.unAuthenticatedStore,
                                    action: AppStore.Action.unAuthenticated
                                )
                        )
                        .onOpenURL { url in
                            if AuthApi.isKakaoTalkLoginUrl(url) {
                                AuthController.handleOpenUrl(url: url)
                            }
                        }
                    case .authenticated:
                        TabBarView(
                            store: appDelegate.store.scope(
                                state: \.tabBarState,
                                action: AppStore.Action.tabBar
                            )
                        )
                    }

                    if viewStore.isLoading {
                        LaunchScreen()
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
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
