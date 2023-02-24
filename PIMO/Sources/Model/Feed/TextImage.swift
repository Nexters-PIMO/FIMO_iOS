//
//  TextImage.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/18.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct TextImage: Decodable, Equatable, Hashable {
    let id: Int
    let imageURL: String
    let text: String
    
    init(id: Int = 0, imageURL: String = "", text: String = "") {
        self.id = id
        self.imageURL = imageURL
        self.text = text
    }
}
