//
//  User.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import Combine
import ComposableArchitecture

class UserUtill: ObservableObject {
    private static let userDefaults = UserDefaults.standard
    private static let decoder = JSONDecoder()
    private static let encoder = JSONEncoder()

    static let shared = UserUtill()

    private init() { }

    func setUserDefaults<T: Encodable>(key: UserDefaultsKeys, value: T) {
        guard let data = try? UserUtill.encoder.encode(value) else {
            return
        }

        UserUtill.userDefaults.set(data, forKey: key.description)
    }

    private func getUserDefaults<T: Decodable>(key: UserDefaultsKeys) -> T? {
        guard let data = UserUtill.userDefaults.object(forKey: key.description) as? Data,
              let object = try? UserUtill.decoder.decode(T.self, from: data) else {
            return nil
        }

        return object
    }

    func getToken() -> MemberToken? {
        guard let memberToken: MemberToken = getUserDefaults(key: UserDefaultsKeys.token) else {
            return nil
        }

        return memberToken
    }
}
