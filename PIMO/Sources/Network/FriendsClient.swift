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
    let fetchFriendsList: () -> [FriendList]
}

extension DependencyValues {
    var friendsClient: FriendsClient {
        get { self[FriendsClient.self] }
        set { self[FriendsClient.self] = newValue }
    }
}

extension FriendsClient: DependencyKey {
    static let liveValue = Self.init {
        // TODO: 서버 통신
        return [
            FriendList(count: 2, friendType: .mutualFriends, friends: [
                .init(friendType: .mutualFriends, prifileImageURL: "", name: "김옥현", archiveName: "하루", count: 2),
                .init(friendType: .mutualFriends, prifileImageURL: "", name: "김김김", archiveName: "이틀", count: 1)
            ]),
            FriendList(count: 2, friendType: .myFriends, friends: [
                .init(friendType: .mutualFriends, prifileImageURL: "", name: "김옥현", archiveName: "하루", count: 2),
                .init(friendType: .mutualFriends, prifileImageURL: "", name: "김김김", archiveName: "이틀", count: 1)
            ]),
            FriendList(count: 2, friendType: .theirFriends, friends: [
                .init(friendType: .mutualFriends, prifileImageURL: "", name: "김옥현", archiveName: "하루", count: 2),
                .init(friendType: .mutualFriends, prifileImageURL: "", name: "김김김", archiveName: "이틀", count: 1)
            ])
        ]
    }
}
