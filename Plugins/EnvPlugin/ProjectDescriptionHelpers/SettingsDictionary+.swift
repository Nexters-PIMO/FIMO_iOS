import ProjectDescription

public extension SettingsDictionary {
    static let baseSettings: Self = [
        "OTHER_LDFLAGS" : []
    ]
    
    func setCodeSignManual() -> SettingsDictionary {
        return merging([
            "CODE_SIGN_STYLE": SettingValue(stringLiteral: "Manual"),
            "DEVELOPMENT_TEAM": SettingValue(stringLiteral: "NY37VGJ3HF"),
            "CODE_SIGN_IDENTITY": SettingValue(stringLiteral: "$(CODE_SIGN_IDENTITY)")
        ])
    }
    
    func setProvisioning() -> SettingsDictionary {
        return merging([
            "PROVISIONING_PROFILE_SPECIFIER": SettingValue(stringLiteral: "$(APP_PROVISIONING_PROFILE)"),
            "PROVISIONING_PROFILE": SettingValue(stringLiteral: "$(APP_PROVISIONING_PROFILE)")
        ])
    }
}
