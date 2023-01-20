import ProjectDescription

extension Project {
    public static func app(name: String,
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
        
        return Project(name: name,
                       organizationName: Environment.organizationName,
                       targets: targets)
    }
}
