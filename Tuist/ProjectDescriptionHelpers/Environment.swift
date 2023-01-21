import ProjectDescription

public enum Environment {
    public static let bundleId: String = "com.nexters.pimo"
    public static let organizationName: String = "pimo"
    public static let deploymentTarget: DeploymentTarget = .iOS(targetVersion: "16.0", devices: [.iphone])
}
