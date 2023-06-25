//
//  FMFollowMe.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct FMFollowMeDTO: Decodable, Equatable {
    let id: String
    let nickname: String
    let archiveName: String
    let profileImageUrl: String
    let postCount: Int
    let status: String // FOLLOWING FOLLOWER MUTUAL

    func toModel() -> FMFollowMe {
        return .init(
            id: id,
            nickname: nickname,
            archiveName: archiveName,
            profileImageUrl: profileImageUrl,
            postCount: postCount,
            status: status
        )
    }
}
