//
//  FMUserProfileUpdateRequest.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

struct FMUserProfileUpdateRequest: Requestable {
    typealias Response = FMProfileDTO
    let nickname: String
    let archiveName: String
    let profileImageUrl: String

    var path: String {
        return "/user/profile/update"
    }

    var method: HTTPMethod {
        return .post
    }

    var parameters: Parameters {
        return [
            "nickname": nickname,
            "archiveName": archiveName,
            "profileImageUrl": profileImageUrl
        ]
    }

    var header: [HTTPFields: String] {
        return [
            HTTPFields.authorization: HTTPHeaderType.authorization.header
        ]
    }
}
