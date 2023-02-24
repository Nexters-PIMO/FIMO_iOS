//
//  Feed.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/18.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct Feed: Decodable, Equatable {
    let id: Int
    let profile: Profile
    let uploadTime: String
    let textImages: [TextImage]
    let clapCount: Int
    let isClapped: Bool
    
    init(id: Int = 0,
         profile: Profile = .init(),
         uploadTime: String = "",
         textImages: [TextImage] = [],
         clapCount: Int = 0,
         isClapped: Bool = false) {
        self.id = id
        self.profile = profile
        self.uploadTime = uploadTime
        self.textImages = textImages
        self.clapCount = clapCount
        self.isClapped = isClapped
    }
}
