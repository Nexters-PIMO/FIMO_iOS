//
//  FMPostDTO.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct FMPostDTO: Decodable, Equatable {
    let id: String
    let user: FMPostUserDTO
    let favorite: Int
    let isClicked: Bool
    let createdAt: String
    let items: [FMPostItemDTO]

    func toModel() -> FMPost {
        return .init(
            id: id,
            user: user.toModel(),
            clapCount: favorite,
            isClapped: isClicked,
            uploadTime: createdAt.toUploadTime(),
            textImages: items.map { $0.toModel() }
        )
    }
}
