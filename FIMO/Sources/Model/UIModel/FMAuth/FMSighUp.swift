//
//  FMSighUp.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct FMSignUp: Equatable {
    let provider: String
    let identifier: String
    let nickname: String
    let archiveName: String
    let profileImageUrl: String

    init(provider: String = "iOS", identifier: String, nickname: String, archiveName: String, profileImageUrl: String) {
        self.provider = provider
        self.identifier = identifier
        self.nickname = nickname
        self.archiveName = archiveName
        self.profileImageUrl = profileImageUrl
    }
}
