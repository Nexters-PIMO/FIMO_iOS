//
//  FriendsListSortType.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/23.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

enum FriendListSortType: String {
    case created = "CREATED"
    case alpahabetical = "ALPAHABETICAL"
}

extension FriendListSortType: CustomStringConvertible {
    var description: String {
        return self.rawValue
    }
}
