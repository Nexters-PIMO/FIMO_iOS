//
//  FMFollowingRequest.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/24.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

struct FMFollowingRequest: Requestable {
    typealias Response = FMServerDescriptionDTO
    let followerID: String

    var path: String {
        return "/follow/following/\(followerID)"
    }

    var method: HTTPMethod {
        return .post
    }

    var parameters: Parameters = [:]

    var header: [HTTPFields: String] = [
        HTTPFields.authorization: HTTPHeaderType.authorization.header
    ]
}
