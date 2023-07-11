//
//  FMDeletePostRequest.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

struct FMDeletePostRequest: Requestable {
    typealias Response = FMServerDescriptionDTO
    let postId: String

    var path: String {
        return "/post/delete/\(postId)"
    }

    var method: HTTPMethod {
        return .delete
    }

    var parameters: Parameters = [:]

    var header: [HTTPFields: String] {
        return [
            HTTPFields.authorization: HTTPHeaderType.authorization.header
        ]
    }
}
