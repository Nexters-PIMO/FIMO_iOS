//
//  FMFollowMe.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct FMFriend {
    let id: String
    let nickname: String
    let archiveName: String
    let profileImageUrl: String
    let postCount: Int
    var status: String // FOLLOWING FOLLOWED MUTUAL
    var willDelete: Bool = false
}

extension FMFriend: Hashable, Equatable, Identifiable {
    var friendType: FriendType {
        guard let type = FriendType(rawValue: self.status) else {
            Log.error("FriendType init시 다른 상태값이 있습니다.")
            return .mutualFriends
        }

        return type
    }

    mutating func toggleFriendStatus() {
        switch friendType {
        case .mutualFriends:
            status = "FOLLOWED"
        case .myFriends:
            willDelete = true
        case .theirFriends:
            status = "MUTUAL"
        }
    }

    static let EMPTY: FMFriend = {
        return .init(
            id: "",
            nickname: "",
            archiveName: "",
            profileImageUrl: "",
            postCount: 0,
            status: ""
        )
    }()
}
