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
}

extension DependencyValues {
    var friendsClient: FriendsClient {
        get { self[FriendsClient.self] }
        set { self[FriendsClient.self] = newValue }
    }
}

extension FriendsClient: DependencyKey {
    static let liveValue = Self.init { (sortType) in
        let request = FMFollowMeRequest()

        return BaseNetwork.shared.request(api: request, isInterceptive: true)
            .catchToEffect()
    }
}
