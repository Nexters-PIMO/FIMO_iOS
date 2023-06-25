//
//  UpdatedPostDTO.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct FMUpdatedPostDTO: Decodable, Equatable {
    let items: [FMUpdatedPostItemDTO]

    func toModel() -> FMUpdatedPost {
        return .init(items: items.map({ $0.toModel() }))
    }
}
