import ProjectDescription

extension Project {
    static let infoPlist: [String: InfoPlist.Value] = [
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "UIMainStoryboardFile": "",
        "UILaunchStoryboardName": "LaunchScreen",
        "UIUserInterfaceStyle": "Light",
        "LSApplicationQueriesSchemes": ["kakaokompassauth"],
        "KAKAO_NATIVE_APP_KEY": "${KAKAO_NATIVE_APP_KEY}"
    ]
}
