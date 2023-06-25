//
//  FMPostItemDTO.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct FMPostItemDTO: Decodable, Equatable {
    let imageUrl: String
    let content: String

    func toModel() -> FMPostItem {
        return .init(imageUrl: imageUrl, content: content)
    }
}
