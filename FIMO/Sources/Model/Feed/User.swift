//
//  User.swift
//  PIMO
//
//  Created by 김영인 on 2023/03/29.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct User: Equatable, Hashable {
    let userId: String
    let nickName: String
    let profileImage: String
    
    static let EMPTY: User = .init(
        userId: "",
        nickName: "",
        profileImage: ""
    )
}
