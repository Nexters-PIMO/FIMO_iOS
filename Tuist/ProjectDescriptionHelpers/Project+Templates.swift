import ProjectDescription
import EnvPlugin

extension Project {
    public static func app(
        name: String,
        platform: Platform,
        dependencies: [TargetDependency] = [])
    
    -> Project {
        
        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "\(Environment.bundleId)",
            infoPlist: .extendingDefault(with: Project.infoPlist),
            sources: ["\(name)/Sources/**"],
            resources: ["\(name)/Resources/**", "Tuist/Dependencies/Lockfiles/Package.resolved"],
            entitlements: "\(name)/\(name).entitlements",
            scripts: [.SwiftLintShell],
            dependencies: dependencies,
            launchArguments: [LaunchArgument(name: "-FIRDebugEnabled", isEnabled: true)]
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
        
        let baseSettings: SettingsDictionary = .baseSettings.setCodeSignManual().setProvisioning()
        let configSettings: [Configuration] = [
            .debug(name: "Debug", xcconfig: .relativeToRoot("\(name)/Resources/Config.xcconfig")),
            .release(name: "Release", xcconfig: .relativeToRoot("\(name)/Resources/Config.xcconfig"))
        ]
        
        return Project(
            name: name,
            organizationName: Environment.organizationName,
            packages: [
                .remote(url: "https://github.com/firebase/firebase-ios-sdk", requirement: .upToNextMajor(from:"10.7.0"))
            ],
            settings: .settings(base: baseSettings, configurations: configSettings),
            targets: targets
        )
    }
}
