//
//  FriendType.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/23.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

enum FriendType: Int {
    // 서로 친구
    case mutualFriends = 0
    // 나만 친구
    case myFriends = 1
    // 상대만 친구
    case theirFriends = 2

    var index: Int {
        return self.rawValue
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
            return Image(uiImage: PIMOAsset.Assets.mutualFriends.image)
        case .myFriends:
            return Image(uiImage: PIMOAsset.Assets.myFriends.image)
        case .theirFriends:
            return Image(uiImage: PIMOAsset.Assets.theirFriends.image)
        }
    }

    var noRelationshipImage: Image {
        switch self {
        case .mutualFriends:
            return Image(uiImage: PIMOAsset.Assets.mutualFriendsNoActive.image)
        case .myFriends:
            return Image(uiImage: PIMOAsset.Assets.myFriendsNoActive.image)
        case .theirFriends:
            return Image(uiImage: PIMOAsset.Assets.theirFriendsNoActive.image)
        }
    }
}

extension FriendType: CaseIterable { }
