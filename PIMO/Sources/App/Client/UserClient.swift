//
//  UserClient.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/27.
//  Copyright © 2023 pimo. All rights reserved.
//

import Combine
import SwiftUI

import ComposableArchitecture

struct UserClient {
    let getToken: () -> MemberToken?
    let setToken: (_ token: MemberToken) -> Void
}

extension UserClient {
    static let live: Self = .init(
        getToken: {
            UserUtill.shared.getToken()
        },
        setToken: { token in
            UserUtill.shared.setUserDefaults(key: UserDefaultsKeys.token, value: token)
        }
    )
}
