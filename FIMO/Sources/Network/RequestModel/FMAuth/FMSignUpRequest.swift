//
//  FMSignUpRequest.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

struct FMSignUpRequest: Requestable {
    typealias Response = FMServerDescriptionDTO
    let signUpModel: FMSignUp

    var path: String {
        return "/auth/signup"
    }

    var method: HTTPMethod {
        return .post
    }

    var parameters: Parameters {
        return [
            "provider": signUpModel.provider,
            "identifier": signUpModel.identifier,
            "nickname": signUpModel.nickname,
            "archiveName": signUpModel.archiveName,
            "profileImageUrl": signUpModel.profileImageUrl
        ]
    }

    var header: [HTTPFields: String] = [:]
}
