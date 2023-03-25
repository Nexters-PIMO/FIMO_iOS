//
//  TextImageDTO.swift
//  PIMO
//
//  Created by 김영인 on 2023/03/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct TextImageDTO: Decodable, Equatable {
    let id: Int
    let caption: String
    let url: String
    
    func toModel() -> TextImage {
        return TextImage(
            id: self.id,
            imageURL: self.url,
            text: self.caption
        )
    }
}
