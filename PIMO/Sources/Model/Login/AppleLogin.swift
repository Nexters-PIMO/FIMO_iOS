//
//  AppleLogin.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct AppleLogin: Decodable, Equatable {
    let message: String
    let status: String
    let data: AppleToken?
}

struct AppleToken: Decodable, Equatable {
    let accessToken: String
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

struct EncodeLogin: Decodable, Equatable {
    let message: String
    let status: String
    let data: EncodedToken?
}

struct EncodedToken: Decodable, Equatable {
    let provider: String
    let accessToken: String
}
