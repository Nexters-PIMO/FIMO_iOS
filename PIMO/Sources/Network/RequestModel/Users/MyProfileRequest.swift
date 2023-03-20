//
//  MyUsersRequest.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/03/15.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

struct ProfileRequest: Requestable {
    typealias Response = Profile

    var path: String {
        return "users"
    }

    var method: Alamofire.HTTPMethod {
        return .get
    }

    var parameters: Parameters = [:]
}
