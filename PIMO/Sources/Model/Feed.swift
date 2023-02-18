//
//  Feed.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/18.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct Feed: Decodable, Equatable {
    let profile: Profile
    let uploadTime: String
    let textImages: [TextImage]
    let clapCount: Int
    let isClapped: Bool
}
