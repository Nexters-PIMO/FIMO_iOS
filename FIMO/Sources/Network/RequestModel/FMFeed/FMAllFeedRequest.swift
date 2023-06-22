//
//  FMAllFeedRequest.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

struct FMAllFeedRequest: Requestable {
    typealias Response = [FMPostDTO]

    var path: String {
        return "/feed"
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
