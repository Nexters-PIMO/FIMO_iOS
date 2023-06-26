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
        var userName: String?
        var currentTab: FriendType = .mutualFriends
        var selectedSort: FriendListSortType = .newest
        var rowFriendsList: [FMFriend] = [FMFriend]() {
            didSet {
                let array = Array(repeating: [FMFriend](), count: FriendType.allCases.count)
                friendsList = rowFriendsList.reduce(into: array, { result, friend in
                    result[friend.friendType.index].append(friend)
                })
            }
        }
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
        case tappedRequestFriendButton(FMFriend)
        case tappedRequestFriendDone(FMFriend, Result<FMServerDescriptionDTO, NetworkError>)
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
                    state.rowFriendsList = friends.map({ $0.toModel() })
                case .failure:
                    return .none
                }
                return .none
            case .tappedRequestFriendDone(let friend, let result):
                switch result {
                case .success:
                    var resultFriend = friend
                    resultFriend.toggleFriendStatus()

                    state.friendsList = state.friendsList.map { innerArray in
                        innerArray.filter({
                            $0 != friend
                        })
                    }

                    if !resultFriend.willDelete {
                        state.friendsList[resultFriend.friendType.index].append(resultFriend)
                    }

                    return .none
                case .failure:
                    return .none
                }
            case .tappedNewestButton:
                state.selectedSort = .newest
                return .none
            case .tappedCharactorOrderButton:
                state.selectedSort = .characterOrder
                return .none
            case .refreshFriendList:
                return .send(.fetchFriendsList)
            default:
                break
            }
            return .none
        }
    }
}
