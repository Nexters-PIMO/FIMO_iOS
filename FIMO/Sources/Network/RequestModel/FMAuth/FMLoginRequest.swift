//
//  FMLoginRequest.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

struct FMLoginRequest: Requestable {
    typealias Response = MemberToken
    // User 식별자
    let identifier: String
    // 플랫폼
    let provider: String = "iOS"

    var path: String {
        return "/post/auth/login"
    }

    var method: HTTPMethod {
        return .post
    }

    var parameters: Parameters {
        [
            "identifier": identifier,
            "provider": provider
        ]
    }

    var header: [HTTPFields: String] = [:]
}
