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
        var userName: String = ""
        var currentTab: FriendType = .mutualFriends
        var selectedSort: FriendListSortType = .newest
        var friendsList: [[FMFriend]] = Array(repeating: [FMFriend](), count: FriendType.allCases.count)

        var selectedFriendsList: [FMFriend] {
            return friendsList[currentTab.index]
        }
    }

    enum Action: Equatable {
        case onAppear
        case tappedTab(String)
        case fetchFriendsList
        case fetchFriendsListDone(Result<[FMFriendDTO], NetworkError>)
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
                let effects: [EffectTask<FriendsListStore.Action>] = [
                    .send(.tappedTab(FriendType.mutualFriends.description)),
                    .send(.fetchFriendsList)
                ]
                return .merge(effects)
            case .tappedTab(let statusName):
                state.currentTab = FriendType(rawValue: statusName) ?? .mutualFriends
                return .none
            case .fetchFriendsList:
                let fetchResult = friendsClient.fetchFriendsList(.newest)
                return fetchResult.map {
                    Action.fetchFriendsListDone($0)
                }
            case .fetchFriendsListDone(let result):
                switch result {
                case .success(let friends):
                    var array = Array(repeating: [FMFriend](), count: FriendType.allCases.count)
                    state.friendsList = friends
                        .reduce(into: array, { result, friendDTO in
                            let friend = friendDTO.toModel()
                            result[friend.friendType.index].append(friend)
                        })
                case .failure(_):
                    return .none
                }
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
