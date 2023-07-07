//
//  FMAllPostRequest.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

enum FMAllPostTarget {
    case me
    case another(String)
}

struct FMAllPostRequest: Requestable {
    typealias Response = [FMPostDTO]
    let target: FMAllPostTarget

    var path: String {
        switch target {
        case .me:
            return "/post"
        case .another(let userId):
            return "/post/user/\(userId)"
        }
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
