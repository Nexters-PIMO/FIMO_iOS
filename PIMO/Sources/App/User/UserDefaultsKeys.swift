//
//  UserDefaultsKeys.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

enum UserDefaultsKeys {
    case token
}

extension UserDefaultsKeys: CustomStringConvertible {
    var description: String {
        switch self {
        case .token:
            return "token"
        }
    }
}
