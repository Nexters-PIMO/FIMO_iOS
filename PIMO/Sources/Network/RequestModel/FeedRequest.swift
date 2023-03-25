//
//  FeedRequest.swift
//  PIMO
//
//  Created by 김영인 on 2023/03/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

enum FeedTarget {
    case postClap(Int)
    case postDeclaration(Int)
}

struct FeedRequest: Requestable {
    typealias Response = Bool
    let target: FeedTarget
    
    #warning("로그인 후 수정")
    var path: String {
        switch target {
        case let .postClap(feedId):
            return "/users/\(PIMOStrings.userId)/feeds/\(feedId)/clap"
        case let .postDeclaration(feedId):
            return "/users/\(PIMOStrings.userId)/feeds/\(feedId)/reports"
        }
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
