//
//  FeedActionRequest.swift
//  PIMO
//
//  Created by 김영인 on 2023/03/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

enum FeedTarget {
    case postClap(String)
    case deleteFeed(String)
    case postDeclaration(String)
}

struct FeedActionRequest: Requestable {
    typealias Response = Bool
    let target: FeedTarget
    
    var path: String {
        switch target {
        case let .postClap(feedId):
            return "/users/\(FIMOStrings.userId)/feeds/\(feedId)/clap"
        case let .deleteFeed(feedId):
            return "/users/\(FIMOStrings.userId)/feeds/\(feedId)"
        case let .postDeclaration(feedId):
            return "/users/\(FIMOStrings.userId)/feeds/\(feedId)/reports"
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
    
    var parameters: Parameters = [:]
    
    var header: [HTTPFields: String] {
        return [
            HTTPFields.authorization: HTTPHeaderType.authorization.header
        ]
    }
}
