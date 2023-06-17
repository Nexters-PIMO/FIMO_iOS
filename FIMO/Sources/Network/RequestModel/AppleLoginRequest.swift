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
    typealias Response = AppleToken

    var path: String {
        return "/login/token"
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }

    var parameters: Parameters
}
