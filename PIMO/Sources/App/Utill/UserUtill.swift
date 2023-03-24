//
//  User.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Combine
import SwiftUI

import ComposableArchitecture

class UserUtill: ObservableObject {
    private let userDefaults = UserDefaults.standard
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    static let shared = UserUtill()
    
    var accessToken: String {
        return self.getToken().accessToken
    }
    
    var refreshToken: String {
        return self.getToken().refreshToken ?? ""
    }

    private init() { }

    func setUserDefaults<T: Encodable>(key: UserDefaultsKeys, value: T) {
        guard let data = try? encoder.encode(value) else {
            return
        }

        userDefaults.set(data, forKey: key.description)
    }

    private func getUserDefaults<T: Decodable>(key: UserDefaultsKeys) -> T? {
        guard let data = userDefaults.object(forKey: key.description) as? Data,
              let object = try? decoder.decode(T.self, from: data) else {
            return nil
        }

        return object
    }

    func getToken() -> MemberToken {
        guard let memberToken: MemberToken = getUserDefaults(key: UserDefaultsKeys.token) else {
            return MemberToken.EMPTY
        }

        return memberToken
    }
    
    func getClosedTextGuide() -> Bool? {
        guard let closedTextGuide: Bool =
                getUserDefaults(key: .closedTextGuide) else {
            return false
        }
        
        return closedTextGuide
    }
}
