import ProjectDescription

public enum Environment {
    public static let bundleId: String = "com.PIMO"
    public static let organizationName: String = "PIMO"
    public static let deploymentTarget: DeploymentTarget = .iOS(targetVersion: "16.0", devices: [.iphone])
}
