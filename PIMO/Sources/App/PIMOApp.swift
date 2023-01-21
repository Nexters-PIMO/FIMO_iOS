import SwiftUI

@main
struct PIMOApp: App {
    @StateObject private var user = User.shared

    #warning("TCA 방식 추후 적용")
    var body: some Scene {
        WindowGroup {
            Group {
                switch user.status {
                    case .unAuthenticated:
                        LoginView()
                    case .authenticated:
                        HomeView()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .tokenExpired)) { _ in
                #warning("TCA 맞춰 재로그인 구현 필요")
            }
        }
    }
}
