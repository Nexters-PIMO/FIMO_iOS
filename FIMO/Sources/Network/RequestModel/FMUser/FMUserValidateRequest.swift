//
//  FMUserValidateRequest.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

enum FMUserValidateTarget {
    case nickname(name: String)
    case archive(name: String)
}

struct FMUserValidateRequest: Requestable {
    typealias Response = Bool
    let target: FMUserValidateTarget

    var path: String {
        switch target {
        case .nickname:
            return "/user/validate/nickname"
        case .archive:
            return "/user/validate/archive"
        }
    }

    var method: HTTPMethod {
        return .get
    }

    var parameters: Parameters {
        switch target {
        case .nickname(let name):
            return ["nickname": name]
        case .archive(let name):
            return ["archive": name]
        }
    }

    var header: [HTTPFields: String] {
        return [
            HTTPFields.authorization: HTTPHeaderType.authorization.header
        ]
    }
}
