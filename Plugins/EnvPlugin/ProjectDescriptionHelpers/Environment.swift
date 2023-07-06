import ProjectDescription

public enum Environment {
    public static let bundleId: String = "com.nexters.ios.fimo"
    public static let organizationName: String = "fimo"
    public static let deploymentTarget: DeploymentTarget = .iOS(targetVersion: "16.0", devices: [.iphone])
}
