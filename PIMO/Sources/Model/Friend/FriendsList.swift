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
    let nickName: String
    let friendType: FriendType
    let friends: [Friend]
}

extension FriendList: Equatable {
    static var EMPTY: FriendList = .init(count: 0, nickName: "", friendType: .mutualFriends, friends: [Friend]())
}
