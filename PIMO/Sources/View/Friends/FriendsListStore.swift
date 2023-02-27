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
        var friendsList: [FriendList] = Array(repeating: .EMPTY, count: FriendType.allCases.count)

        var selectedFriendsList: FriendList {
            return friendsList[currentTab.index]
        }
    }

    enum Action: Equatable {
        case onAppear
        case tappedTab(Int)
        case fetchFriendsList(FriendType)
        case tappedNewestButton
        case tappedCharactorOrderButton
        case tappedRequestFriendButton(FriendType)
    }

    @Dependency(\.friendsClient) var friendsClient

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.tappedTab(FriendType.mutualFriends.index))
            case .tappedTab(let index):
                state.currentTab = FriendType(rawValue: index) ?? .mutualFriends
                return .send(.fetchFriendsList(state.currentTab))
            case .fetchFriendsList(let type):
                // TODO: Fetch Friends List
                state.friendsList[state.currentTab.index] = friendsClient.fetchFriendsList(type)
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

