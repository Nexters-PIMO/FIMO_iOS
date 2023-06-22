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
    let updateProfile: FMProfile

    var path: String {
        return "/user/profile/update"
    }

    var method: HTTPMethod {
        return .post
    }

    var parameters: Parameters {
        return [
            "nickname": updateProfile.nickname,
            "archiveName": updateProfile.archiveName,
            "profileImageUrl": updateProfile.profileImageUrl
        ]
    }

    var header: [HTTPFields: String] {
        return [
            HTTPFields.authorization: HTTPHeaderType.authorization.header
        ]
    }
}
