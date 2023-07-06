//
//  FMFollowMeRequest.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/24.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

struct FMFollowMeRequest: Requestable {
    typealias Response = [FMFriendDTO]
    let sortType: FriendListSortType

    var path: String {
        return "/follow/me"
    }

    var method: HTTPMethod {
        return .get
    }

    var parameters: Parameters {
        return [
            "sortType": sortType.description
        ]
    }


    var header: [HTTPFields: String] = [
        HTTPFields.authorization: HTTPHeaderType.authorization.header
    ]
}
