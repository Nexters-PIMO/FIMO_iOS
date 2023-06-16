//
//  FriendsClient.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/23.
//  Copyright © 2023 pimo. All rights reserved.
//

import Combine
import Foundation

import ComposableArchitecture

struct FriendsClient {
    let fetchFriendsList: (FriendType) -> FriendList
}

extension DependencyValues {
    var friendsClient: FriendsClient {
        get { self[FriendsClient.self] }
        set { self[FriendsClient.self] = newValue }
    }
}

extension FriendsClient: DependencyKey {
    static let liveValue = Self.init { friendType in
        // TODO: 서버 통신
        return FriendList(count: 2, nickName: "EOEUNNOO", friendType: friendType, friends: [
            .init(friendType: friendType, profileImageURL: FIMOStrings.otherProfileImage, name: "CHERISHER_Y", archiveName: "하루", count: 2,  isMyRelationship: true),
            .init(friendType: friendType, profileImageURL: FIMOStrings.profileImage, name: "0inn", archiveName: "파도의 거품", count: 1, isMyRelationship: true)
        ])
    }
}
