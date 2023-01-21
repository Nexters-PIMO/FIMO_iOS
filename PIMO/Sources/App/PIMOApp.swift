import SwiftUI

@main
struct PIMOApp: App {
    @StateObject private var user = User.shared

    #warning("TCA 방식 추후 적용")
    var body: some Scene {
        WindowGroup {
            switch user.status {
                case .unAuthenticated:
                    LoginView()
                case .authenticated:
                    HomeView()
            }
        }
    }
}
