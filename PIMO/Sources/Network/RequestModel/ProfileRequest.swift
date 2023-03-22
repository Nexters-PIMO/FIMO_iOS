//
//  ProfileRequest.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/03/15.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

enum ProfileTarget {
    case fetchMyProfile
    case fetchOtherProfile(String)
}

struct ProfileRequest: Requestable {
    typealias Response = Profile
    let target: ProfileTarget
    
    var path: String {
        switch target {
        case .fetchMyProfile:
            return "/users"
        case .fetchOtherProfile:
            return "/users/search"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters {
        switch target {
        case .fetchMyProfile:
            return [:]
        case let .fetchOtherProfile(userId):
            return ["userId": userId]
        }
    }
    
    var header: [HTTPFields: String] {
        return [
            HTTPFields.authorization: HTTPHeaderType.authorization.header
        ]
    }
}
