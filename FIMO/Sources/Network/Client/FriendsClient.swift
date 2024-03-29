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
    let fetchFriendsList: (FriendListSortType) -> EffectPublisher<Result<[FMFriendDTO], NetworkError>, Never>
    let followFriend: (String) -> EffectPublisher<Result<FMServerDescriptionDTO, NetworkError>, Never>
    let unfollowFriend: (String) -> EffectPublisher<Result<FMServerDescriptionDTO, NetworkError>, Never>
}

extension DependencyValues {
    var friendsClient: FriendsClient {
        get { self[FriendsClient.self] }
        set { self[FriendsClient.self] = newValue }
    }
}

extension FriendsClient: DependencyKey {
    static let liveValue = Self.init { (sortType) in
        let request = FMFollowMeRequest(sortType: sortType)

        return BaseNetwork.shared.request(api: request, isInterceptive: true)
            .catchToEffect()
    } followFriend: { id in
        let request = FMFollowingRequest(followerID: id)

        return BaseNetwork.shared.request(api: request, isInterceptive: true)
            .catchToEffect()
    } unfollowFriend: { id in
        let request = FMUnfollowingRequest(unfollowerID: id)

        return BaseNetwork.shared.request(api: request, isInterceptive: true)
            .catchToEffect()
    }
}
