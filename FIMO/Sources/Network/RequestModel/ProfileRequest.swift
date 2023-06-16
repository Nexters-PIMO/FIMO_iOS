//
//  ProfileRequest.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/03/15.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

enum ProfileTarget {
    case fetchMyProfile
    case fetchOtherProfile(String)

#warning("API 미확정")
    case saveProfile(nickname: String, archiveName: String, profileImgURL: String)
    case patchNickname(nickname: String)

#warning("API 미확정")
    case patchArchiveName(archiveName: String)
    case patchprofileImage(profilImageURL: String)
}

struct ProfileRequest: Requestable {
    typealias Response = Profile
    let target: ProfileTarget
    
    var path: String {
        switch target {
        case .fetchMyProfile, .saveProfile:
            return "/users"
        case .fetchOtherProfile:
            return "/users/search"
        case .patchNickname:
            return "users/nickname"
        case .patchArchiveName:
            return "users/archiveName"
        case .patchprofileImage:
            return "users/profile"
        }
    }
    
    var method: HTTPMethod {
        switch target {
        case .fetchMyProfile, .fetchOtherProfile:
            return .get
        case .saveProfile:
            return .post
        case .patchprofileImage, .patchNickname, .patchArchiveName:
            return .patch
        }
    }
    
    var parameters: Parameters {
        switch target {
        case .fetchMyProfile:
            return [:]
        case let .fetchOtherProfile(userId):
            return ["userId": userId]
        case let .saveProfile(nickname, archiveName, profileImgURL):
            return [
                "nickName": nickname,
                "archiveName": archiveName,
                "profileImgUrl": profileImgURL
            ]
        case let .patchNickname(nickname):
            return [
                "nickname": nickname
            ]
        case let .patchArchiveName(archiveName):
            return [
                "archiveName": archiveName
            ]
        case let .patchprofileImage(profilImageURL):
            return [
                "profile": profilImageURL
            ]
        }
    }
    
    var header: [HTTPFields: String] {
        return [
            HTTPFields.authorization: HTTPHeaderType.authorization.header
        ]
    }
}
