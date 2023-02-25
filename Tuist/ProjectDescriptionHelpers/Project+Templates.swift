import ProjectDescription

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
            resources: ["\(name)/Resources/**"],
            entitlements: "\(name)/\(name).entitlements",
            scripts: [.SwiftLintShell],
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
        
        let settings = Settings.settings(configurations: [
                .debug(name: "Debug", xcconfig: .relativeToRoot("\(name)/Resources/Config.xcconfig")),
                .release(name: "Release", xcconfig: .relativeToRoot("\(name)/Resources/Config.xcconfig"))
            ])
        
        return Project(
            name: name,
            organizationName: Environment.organizationName,
            settings: settings,
            targets: targets)
    }
}
