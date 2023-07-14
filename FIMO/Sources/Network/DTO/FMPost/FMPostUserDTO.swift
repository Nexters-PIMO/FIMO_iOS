//
//  FMPostUserDTO.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct FMPostUserDTO: Decodable, Equatable {
    let id: String
    let nickname: String
    let archiveName: String

    func toModel() -> FMPostUser {
        return .init(
            id: id,
            nickname: nickname,
            archiveName: archiveName,
            profileImage: ""
        )
    }
}
