//
//  FMUnfollowingRequest.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/24.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

struct FMUnfollowingRequest: Requestable {
    typealias Response = FMServerDescriptionDTO
    let unfollowerID: String

    var path: String {
        return "/follow/unfollowing/\(unfollowerID)"
    }

    var method: HTTPMethod {
        return .post
    }

    var parameters: Parameters = [:]

    var header: [HTTPFields: String] = [
        HTTPFields.authorization: HTTPHeaderType.authorization.header
    ]
}
