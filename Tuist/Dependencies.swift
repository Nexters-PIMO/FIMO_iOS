import ProjectDescription

let spm = SwiftPackageManagerDependencies([
    .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMinor(from: "5.6.4")),
    .remote(url: "https://github.com/pointfreeco/swift-composable-architecture", requirement: .upToNextMajor(from: "0.51.0")),
    .remote(url: "https://github.com/onevcat/Kingfisher", requirement: .upToNextMajor(from: "7.6.1")),
    .remote(url: "https://github.com/vtourraine/AcknowList", requirement: .upToNextMajor(from: "3.0.0")),
    .remote(url: "https://github.com/kakao/kakao-ios-sdk", requirement: .upToNextMajor(from: "2.13.1"))
])

let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: spm,
    platforms: [.iOS]
)
