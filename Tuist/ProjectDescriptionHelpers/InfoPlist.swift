import ProjectDescription

extension Project {
    static let infoPlist: [String: InfoPlist.Value] = [
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "UIMainStoryboardFile": "",
        "UILaunchStoryboardName": "LaunchScreen",
        "UIUserInterfaceStyle": "Light",
        "LSApplicationQueriesSchemes": ["kakaokompassauth"],
        "KAKAO_NATIVE_APP_KEY": "${KAKAO_NATIVE_APP_KEY}",
        "BaseURL": "${BASE_URL}",
        "ClientID": "${CLIENT_ID}",
        "ImgurURL": "${IMGUR_URL}",
        "DynamicLinkURL": "${DYNAMIC_LINK}",
        "CFBundleURLTypes": [
            [
                "CFBundleTypeRole": "Editor",
                "CFBundleURLSchemes": ["kakao$(KAKAO_NATIVE_APP_KEY)"]
            ],
            [
                "CFBundleTypeRole": "Editor",
                "CFBundleURLSchemes": ["$(DYNAMIC_LINK)"]
            ]
        ]
    ]
}
