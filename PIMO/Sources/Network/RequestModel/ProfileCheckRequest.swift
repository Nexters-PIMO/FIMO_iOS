//
//  ProfileCheckRequest.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/03/27.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

enum ProfileCheckTarget {
    case deleteProfile
    case fetchIsExistsNickname(String)
#warning("API 미확정")
    case fetchIsExistsArchiveName(String)
}

struct ProfileCheckRequest: Requestable {
    typealias Response = Bool
    let target: ProfileCheckTarget

    var path: String {
        switch target {
        case .deleteProfile:
            return "/users"
        case .fetchIsExistsNickname:
            return "users/exists/nickname"
        case .fetchIsExistsArchiveName:
            return "users/exists/archiveName"
        }
    }

    var method: HTTPMethod {
        switch target {
        case .fetchIsExistsNickname, .fetchIsExistsArchiveName:
            return .get
        case .deleteProfile:
            return .delete
        }
    }

    var parameters: Parameters {
        switch target {
        case .deleteProfile:
            return [:]
        case let .fetchIsExistsNickname(nickname):
            return [
                "nickname": nickname
            ]
        case let .fetchIsExistsArchiveName(archiveName):
            return [
                "archiveName": archiveName
            ]
        }
    }

    var header: [HTTPFields: String] {
        return [
            HTTPFields.authorization: HTTPHeaderType.authorization.header
        ]
    }
}

