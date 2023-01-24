//
//  User.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

class User: ObservableObject {
    enum Status {
        case unAuthenticated
        case authenticated
    }

    static var shared = User()

    private let userDefaults = UserDefaults.standard
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    @Published open private(set) var status: User.Status = .unAuthenticated
    private(set) var memberToken: MemberToken?

    private init() {
        if checkHasToken() {
            status = .authenticated
        } else {
            status = .unAuthenticated
        }
    }

    open func setAuthenticatedStatus() {
        status = .authenticated
    }

    open func setUnauthenticatedStatus() {
        status = .unAuthenticated
    }
}

extension User {
    public func setToken(_ memberToken: MemberToken) {
        setUserDefaults(key: .token, value: memberToken)
        self.memberToken = memberToken
    }

    public func setUserDefaults<T: Encodable>(key: UserDefaultsKeys, value: T) {
        guard let data = try? encoder.encode(value) else {
            return
        }

        userDefaults.set(data, forKey: key.description)
    }

    public func getUserDefaults<T: Decodable>(key: UserDefaultsKeys) -> T? {
        guard let data = userDefaults.object(forKey: key.description) as? Data,
              let object = try? decoder.decode(T.self, from: data) else {
            return nil
        }

        return object
    }

    private func checkHasToken() -> Bool {
        guard let memberToken: MemberToken = getUserDefaults(key: UserDefaultsKeys.token) else {
            return false
        }

        self.memberToken = memberToken

        return true
    }
}
