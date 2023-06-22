//
//  FMUpdatePostRequest.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

struct FMUpdatePostRequest: Requestable {
    typealias Response = FMPostDTO
    let updatePostItems: FMUpdatedPost
    let postId: Int

    var path: String {
        return "/post/update/\(postId)"
    }

    var method: HTTPMethod {
        return .put
    }

    var parameters: Parameters {
        return [
            "items": updatePostItems.items.map({
                [
                    "imageUrl": $0.imageUrl,
                    "content": $0.content
                ]
            })
        ]
    }

    var header: [HTTPFields: String] {
        return [
            HTTPFields.authorization: HTTPHeaderType.authorization.header
        ]
    }
}
