//
//  FMAnotherAllPostRequest.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

struct FMAnotherAllPostRequest: Requestable {
    typealias Response = [FMPostDTO]
    let userId: Int

    var path: String {
        return "/post/user/\(userId)"
    }

    var method: HTTPMethod {
        return .get
    }

    var parameters: Parameters = [:]

    var header: [HTTPFields: String] {
        return [
            HTTPFields.authorization: HTTPHeaderType.authorization.header
        ]
    }
}
