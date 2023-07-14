//
//  FMPostActionRequest.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

enum FMPostTarget {
    case postClap(String)
    case deleteFeed(String)
    case postDeclaration(String)
}

struct FMPostActionRequest: Requestable {
    typealias Response = Empty
    let target: FMPostTarget

    var path: String {
        switch target {
        case let .postClap(postId):
            return "/post/favorite/\(postId)"
        case let .deleteFeed(postId):
            return "/post/delete/\(postId)"
        case let .postDeclaration(postId):
            return "/report/create"
        }
    }

    var method: HTTPMethod {
        switch target {
        case .postClap, .postDeclaration:
            return .post
        case .deleteFeed:
            return .delete
        }
    }

    var parameters: Parameters {
        switch target {
        case let .postDeclaration(postId):
            return [
                "postId": postId
            ]
        default:
            return [:]
        }
    }

    var header: [HTTPFields: String] {
        return [
            HTTPFields.authorization: HTTPHeaderType.authorization.header
        ]
    }
}
