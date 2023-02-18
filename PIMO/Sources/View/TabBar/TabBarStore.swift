//
//  TabBarStore.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/13.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct TabBarStore: ReducerProtocol {
    struct State: Equatable {
        @BindableState var tabBarItem: TabBarItem = .home
        @BindableState var isSheetPresented: Bool = false
        var profile: Profile? //= Profile(imageURL: "", nickName: "")
        var homeState = HomeStore.State()
        var uploadState = UploadStore.State()
        var myFeedState = MyFeedStore.State()
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case fetchProfile
        case setSheetState
        case home(HomeStore.Action)
        case upload(UploadStore.Action)
        case myFeed(MyFeedStore.Action)
    }
    
    @Dependency(\.profileClient) var profileClient
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .fetchProfile:
                state.profile = profileClient.fetchProfile()
                return .none
            case .setSheetState:
                state.isSheetPresented = true
                return .none
            default:
                return .none
            }
        }
        
        Scope(state: \.homeState, action: /Action.home) {
            HomeStore()
        }
        
        Scope(state: \.uploadState, action: /Action.upload) {
            UploadStore()
        }
        
        Scope(state: \.myFeedState, action: /Action.myFeed) {
            MyFeedStore()
        }
    }
}
