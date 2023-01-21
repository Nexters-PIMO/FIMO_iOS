//
//  LoginRequest.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

struct AppleLoginRequest: Requestable {
    typealias Response = AppleLogin

    var path: String {
        return "/"
    }

    var baseURL: String {
        NetworkEnvironment.baseURL
    }

    var method: Alamofire.HTTPMethod {
        return .post
    }

    var parameters: Parameters
}
