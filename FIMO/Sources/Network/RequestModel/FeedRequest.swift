//
//  FeedRequest.swift
//  PIMO
//
//  Created by 김영인 on 2023/03/25.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

struct FeedRequest: Requestable {
    typealias Response = FeedDTO
    let feedId: Int
    
    var path: String {
        return "/users/\(FIMOStrings.userId)/feeds/\(feedId)"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters = [:]
    
    var header: [HTTPFields : String] {
        return [
            HTTPFields.authorization: HTTPHeaderType.authorization.header
        ]
    }
    
}
