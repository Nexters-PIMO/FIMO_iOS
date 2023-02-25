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
        var friendsList: [FriendList] = []

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
        case tappedRequestFriendButton(FriendType)
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
                state.selectedSort = .characterOrder
                return .none
            case .tappedRequestFriendButton(let type):
                return .none
            }
        }
    }
}

