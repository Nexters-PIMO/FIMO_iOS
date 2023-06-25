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
        var id: Int?
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
        case fetchFriendsList
        case tappedNewestButton
        case tappedCharactorOrderButton
        case tappedRequestFriendButton
        case refreshFriendList
    }

    @Dependency(\.friendsClient) var friendsClient

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.tappedTab(FriendType.mutualFriends.index))
            case .tappedTab(let index):
                state.currentTab = FriendType(rawValue: index) ?? .mutualFriends
                return .send(.fetchFriendsList)
            case .fetchFriendsList:
                // TODO: Fetch Friends List
                state.friendsList[state.currentTab.index] = friendsClient.fetchFriendsList(state.currentTab, state.selectedSort)
                return .none
            case .tappedNewestButton:
                state.selectedSort = .newest
                return .none
            case .tappedCharactorOrderButton:
                state.selectedSort = .characterOrder
                return .none
            case .tappedRequestFriendButton:
                #warning("친구 추가 버튼 네트워크")
                return .none
            case .refreshFriendList:
                return .send(.fetchFriendsList)
            }
        }
    }
}
