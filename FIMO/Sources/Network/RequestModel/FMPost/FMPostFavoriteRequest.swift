//
//  FMPostFavoriteRequest.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

struct FMPostFavoriteRequest: Requestable {
    typealias Response = Int
    let postId: String

    var path: String {
        return "/post/favorite/\(postId)"
    }

    var method: HTTPMethod {
        return .post
    }

    var parameters: Parameters = [:]

    var header: [HTTPFields: String] {
        return [
            HTTPFields.authorization: HTTPHeaderType.authorization.header
        ]
    }
}
