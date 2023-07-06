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
        @BindingState var isShowToast: Bool = false
        var toastMessage: ToastModel = ToastModel(title: FIMOStrings.textCopyToastTitle,
                                                  message: FIMOStrings.textCopyToastMessage)
        var id: Int?
        var userName: String?
        var currentTab: FriendType = .mutualFriends
        var selectedSort: FriendListSortType = .created
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

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case onAppear
        case sendToast(ToastModel)
        case sendToastDone
        case tappedTab(String)
        case fetchFriendsList(FriendListSortType)
        case fetchFriendsListDone(Result<[FMFriendDTO], NetworkError>)
        case tappedNewestButton
        case tappedCharactorOrderButton
        case tappedRequestFriendButton(FMFriend)
        case tappedRequestFriendDone(FMFriend, Result<FMServerDescriptionDTO, NetworkError>)
        case refreshFriendList
    }

    @Dependency(\.friendsClient) var friendsClient

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .sendToast(toastModel):
                if state.isShowToast {
                    return EffectTask<Action>(value: .sendToast(toastModel))
                        .delay(for: .milliseconds(1000), scheduler: DispatchQueue.main)
                        .eraseToEffect()
                } else {
                    state.isShowToast = true
                    state.toastMessage = toastModel
                    return EffectTask<Action>(value: .sendToastDone)
                        .delay(for: .milliseconds(2000), scheduler: DispatchQueue.main)
                        .eraseToEffect()
                }
            case .sendToastDone:
                state.isShowToast = false
            case .onAppear:
                let effects: [EffectTask<FriendsListStore.Action>] = [
                    .send(.tappedTab(FriendType.mutualFriends.description)),
                    .send(.fetchFriendsList(state.selectedSort))
                ]
                return .merge(effects)
            case .tappedTab(let statusName):
                state.currentTab = FriendType(rawValue: statusName) ?? .mutualFriends
                return .none
            case .fetchFriendsList(let sortType):
                let fetchResult = friendsClient.fetchFriendsList(sortType)
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
                guard state.selectedSort != .created else {
                    return .none
                }
                state.selectedSort = .created
                return .init(value: .fetchFriendsList(state.selectedSort))
            case .tappedCharactorOrderButton:
                guard state.selectedSort != .alpahabetical else {
                    return .none
                }
                state.selectedSort = .alpahabetical
                return .init(value: .fetchFriendsList(state.selectedSort))
            case .refreshFriendList:
                return .send(.fetchFriendsList(state.selectedSort))
            default:
                break
            }
            return .none
        }
    }
}
