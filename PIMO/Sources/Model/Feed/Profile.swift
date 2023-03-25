//
//  Profile.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/03/15.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct Profile: Decodable, Equatable, Hashable {
    let userId: String
    let nickName: String
    let profileImgUrl: String
    let status: String
    let updatedAt: String
    let createdAt: String

    static let EMPTY: Profile = .init(
        userId: "",
        nickName: "",
        profileImgUrl: "",
        status: "",
        updatedAt: "",
        createdAt: ""
    )
}
