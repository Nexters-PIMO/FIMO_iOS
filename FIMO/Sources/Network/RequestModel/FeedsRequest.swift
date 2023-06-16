//
//  FeedsRequest.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/18.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

enum FeedsTarget {
    case fetchHomeFeeds
    case fetchArchiveFeeds
}

struct FeedsRequest: Requestable {
    typealias Response = [FeedDTO]
    let target: FeedsTarget
    
    var path: String {
        #warning("로그인 후 수정")
        return "/users/\(FIMOStrings.userId)/home"
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
