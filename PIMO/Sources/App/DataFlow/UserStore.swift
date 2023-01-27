//
//  UserStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/26.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct UserState: Equatable {
    enum Status {
        case unAuthenticated
        case authenticated
    }

    @BindableState var status: Status = .unAuthenticated
    var token: MemberToken?
}

enum UserAction: Equatable {
    case checkAccessToken
}

struct UserEnvironment {
    let userClient: UserClient
}

let userReducer = AnyReducer<UserState, UserAction, UserEnvironment> { state, action, environment in
    switch action {
    case .checkAccessToken:
        guard let token = environment.userClient.getToken() else {
            state.status = .unAuthenticated
            return .none
        }

        state.status = .authenticated
        state.token = token
        return .none
    }
}
