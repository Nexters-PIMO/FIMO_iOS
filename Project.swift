import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
    name: "FIMO",
    platform: .iOS,
    dependencies: [
        .external(name: "Alamofire"),
        .external(name: "ComposableArchitecture"),
        .external(name: "Kingfisher"),
        .external(name: "AcknowList"),
        .external(name: "KakaoSDK"),
        .external(name: "FLAnimatedImage"),
        .package(product: "FirebaseAnalytics"),
        .package(product: "FirebaseDynamicLinks")
    ])
