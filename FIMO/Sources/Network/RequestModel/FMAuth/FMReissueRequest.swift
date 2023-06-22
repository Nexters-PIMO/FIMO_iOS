//
//  FMReissueRequest.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

struct FMReissueRequest: Requestable {
    typealias Response = MemberToken
    let memberToekn: MemberToken

    var path: String {
        return "/post/auth/reissue"
    }

    var method: HTTPMethod {
        return .post
    }

    var parameters: Parameters {
        return [
            "accessToken": memberToekn.accessToken,
            "refreshToken": memberToekn.refreshToken ?? ""
        ]
    }

    var header: [HTTPFields: String] {
        return [
            HTTPFields.authorization: HTTPHeaderType.authorization.header
        ]
    }
}
