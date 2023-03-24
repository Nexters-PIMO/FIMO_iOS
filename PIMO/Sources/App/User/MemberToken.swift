//
//  MemberToken.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct MemberToken {
    let accessToken: String
    let refreshToken: String?
    
    static var EMPTY: MemberToken = .init(
        accessToken: "",
        refreshToken: ""
    )
}

extension MemberToken: Codable, Equatable { }
