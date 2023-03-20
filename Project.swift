import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

let localHelper = LocalHelper(name: "MyPlugin")

let project = Project.app(
    name: "FIMO",
    platform: .iOS,
    dependencies: [
        .external(name: "Alamofire"),
        .external(name: "ComposableArchitecture"),
        .external(name: "Kingfisher"),
        .external(name: "KakaoSDK"),
        .external(name: "FLAnimatedImage")
    ])
