//
//  FMPostUser.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct FMPostUser: Equatable, Hashable {
    let id: String
    let nickname: String
    let archiveName: String
    let profileImage: String
    
    static var EMPTY: FMPostUser = .init(
        id: "",
        nickname: "",
        archiveName: "",
        profileImage: ""
    )
}
