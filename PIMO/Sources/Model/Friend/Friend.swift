//
//  Friend.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/23.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct Friend {
    let friendType: FriendType
    let prifileImageURL: String
    let name: String
    let archiveName: String
    let count: Int
}

extension Friend: Equatable, Hashable { }
