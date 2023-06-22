//
//  FMReportRequest.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

struct FMReportRequest: Requestable {
    typealias Response = FMServerDescriptionDTO
    let postId: String

    var path: String {
        return "/report/create"
    }

    var method: HTTPMethod {
        return .post
    }

    var parameters: Parameters {
        return [
            "postId": postId
        ]
    }

    var header: [HTTPFields: String] {
        return [
            HTTPFields.authorization: HTTPHeaderType.authorization.header
        ]
    }
}
