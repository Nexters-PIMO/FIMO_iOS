import ProjectDescription

public enum Environment {
    public static let bundleId: String = "com.PIMO"
    public static let organizationName: String = "PIMO"
    public static let deploymentTarget: DeploymentTarget = .iOS(targetVersion: "16.0", devices: [.iphone])
}

extension Project {
    public static func app(name: String,
                           platform: Platform,
                           dependencies: [TargetDependency] = [])
    -> Project {
        
        let infoPlist: [String: InfoPlist.Value] = [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1",
            "UIMainStoryboardFile": "",
            "UILaunchStoryboardName": "LaunchScreen"
        ]
        
        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "\(Environment.bundleId)",
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["\(name)/Sources/**"],
            resources: ["\(name)/Resources/**"],
            dependencies: dependencies
        )

        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: Environment.bundleId,
            infoPlist: .default,
            sources: ["\(name)/Tests/**"],
            dependencies: [
                .target(name: "\(name)")
        ])
        
        let targets: [Target] = [mainTarget, testTarget]
        
        return Project(name: name,
                       organizationName: Environment.organizationName,
                       targets: targets)
    }
}
