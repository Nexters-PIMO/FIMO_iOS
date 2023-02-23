//
//  FriendsListStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/23.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct FriendsListStore: ReducerProtocol {
    struct State: Equatable {
        var currentTab: FriendType = .mutualFriends
        var selectedSort: FriendListSortType = .newest
        var friendsList: [FriendList] = [
            FriendList(count: 2, friendType: .mutualFriends, friends: [
                .init(friendType: .mutualFriends, prifileImageURL: "", name: "김옥현", archiveName: "하루", count: 2),
                .init(friendType: .mutualFriends, prifileImageURL: "", name: "김김김", archiveName: "이틀", count: 1)
            ]),
            FriendList(count: 2, friendType: .myFriends, friends: [
                .init(friendType: .mutualFriends, prifileImageURL: "", name: "김호현", archiveName: "하루", count: 2),
                .init(friendType: .mutualFriends, prifileImageURL: "", name: "김김김", archiveName: "이틀", count: 1)
            ]),
            FriendList(count: 2, friendType: .theirFriends, friends: [
                .init(friendType: .mutualFriends, prifileImageURL: "", name: "호호호", archiveName: "하루", count: 2),
                .init(friendType: .mutualFriends, prifileImageURL: "", name: "김김김", archiveName: "이틀", count: 1)
            ])
        ]

        var selectedFriendsList: FriendList {
            if friendsList.count > currentTab.index {
                return friendsList[currentTab.index]
            } else {
                return .EMPTY
            }
        }
    }

    enum Action: Equatable {
        case tappedTab(Int)
        case fetchFriendsList
        case tappedNewestButton
        case tappedCharactorOrderButton
    }

    @Dependency(\.friendsClient) var friendsClient

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .tappedTab(let index):
                state.currentTab = FriendType(rawValue: index) ?? .mutualFriends
                return .none
            case .fetchFriendsList:
                state.friendsList = friendsClient.fetchFriendsList()
                return .none
            case .tappedNewestButton:
                state.selectedSort = .newest
                return .none
            case .tappedCharactorOrderButton:
                state.selectedSort = .charactorOrder
                return .none
            }
        }
    }
}

