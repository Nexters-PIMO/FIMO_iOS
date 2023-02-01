//
//  UserStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/26.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct UserStore: ReducerProtocol {
    struct State: Equatable {
        enum Status {
            case unAuthenticated
            case authenticated
        }

        var status: Status = .unAuthenticated
        var token: MemberToken?
    }

    enum Action: Equatable {
        case checkAccessToken
    }

    @Dependency(\.userClient) var userClient

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .checkAccessToken:
                guard let token = userClient.getToken() else {
                    state.status = .unAuthenticated
                    return .none
                }
                state.status = .authenticated
                state.token = token
                return .none
            }
        }
    }
}
