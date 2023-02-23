//
//  FriendsList.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/23.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct FriendList {
    let count: Int
    let friendType: FriendType
    let friends: [Friend]
}

extension FriendList: Equatable {
    static var EMPTY: FriendList = .init(count: 30, friendType: .mutualFriends, friends: [Friend]())
}
