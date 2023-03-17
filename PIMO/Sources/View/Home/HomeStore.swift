//
//  HomeStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

enum HomeScene: Hashable {
    case home
    case setting
}

struct HomeStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var path: [HomeScene] = []
        @BindingState var isShowToast: Bool = false
        var toastMessage: ToastModel = ToastModel(title: PIMOStrings.textCopyToastTitle,
                                                  message: PIMOStrings.textCopyToastMessage)
        var feeds: IdentifiedArrayOf<FeedStore.State> = []
        var setting: SettingStore.State?
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case sendToast(ToastModel)
        case sendToastDone
        case fetchFeeds
        case feed(id: FeedStore.State.ID, action: FeedStore.Action)
        case settingButtonDidTap
        case receiveProfileInfo(Profile)
        case setting(SettingStore.Action)
        case onboarding(OnboardingStore.Action)
    }
    
    @Dependency(\.homeClient) var homeClient
    
    private let pasteboard = UIPasteboard.general
    
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
            case .fetchFeeds:
                let feeds = homeClient.fetchFeeds()
                var firstFeed = 0
                if !feeds.isEmpty { firstFeed = feeds[0].id }
                state.feeds = IdentifiedArrayOf(
                    uniqueElements: feeds.map { feed in
                        FeedStore.State(
                            textImage: feed.textImages[0],
                            id: feed.id,
                            feed: feed,
                            isFirstFeed: (feed.id == firstFeed) ? true : false,
                            clapCount: feed.clapCount,
                            isClapped: feed.isClapped
                        )
                    }
                )
            case let .feed(id: _, action: action):
                switch action {
                case let .copyButtonDidTap(text):
                    pasteboard.string = text
                    state.isShowToast = true
                default:
                    break
                }
            case .receiveProfileInfo(let profile):
                // TODO: API 연결 시 보완 예정
                state.setting = SettingStore.State(nickname: profile.nickName,
                                                   archiveName: "",
                                                   imageURLString: profile.profileImgUrl)
                state.path.append(.setting)
            default:
                break
            }
            return .none
        }
        .ifLet(\.setting, action: /Action.setting) {
            SettingStore()
        }
        .forEach(\.feeds, action: /Action.feed(id:action:)) {
            FeedStore()
        }
    }
}
