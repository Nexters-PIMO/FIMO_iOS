//
//  FriendType.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/23.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

enum FriendType: String {
    // 서로 친구, MUTUAL
    case mutualFriends = "MUTUAL"
    // 나만 친구, FOLLOWING
    case myFriends = "FOLLOWING"
    // 상대만 친구, FOLLOWED
    case theirFriends = "FOLLOWED"

    var index: Int {
        switch self {
        case .mutualFriends:
            return 0
        case .myFriends:
            return 1
        case .theirFriends:
            return 2
        }
    }

    var title: String {
        switch self {
        case .mutualFriends:
            return "서로친구"
        case .myFriends:
            return "나만친구"
        case .theirFriends:
            return "상대만친구"
        }
    }

    var image: Image {
        switch self {
        case .mutualFriends:
            return Image(uiImage: FIMOAsset.Assets.mutualFriends.image)
        case .myFriends:
            return Image(uiImage: FIMOAsset.Assets.myFriends.image)
        case .theirFriends:
            return Image(uiImage: FIMOAsset.Assets.theirFriends.image)
        }
    }

    var noRelationshipImage: Image {
        switch self {
        case .mutualFriends:
            return Image(uiImage: FIMOAsset.Assets.mutualFriendsNoActive.image)
        case .myFriends:
            return Image(uiImage: FIMOAsset.Assets.myFriendsNoActive.image)
        case .theirFriends:
            return Image(uiImage: FIMOAsset.Assets.theirFriendsNoActive.image)
        }
    }
}

extension FriendType: CaseIterable, CustomStringConvertible {
    var description: String {
        return self.rawValue
    }
}
