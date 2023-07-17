//
//  FMPost.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct FMPost: Equatable, Hashable, Identifiable {
    let id: String
    let user: FMPostUser
    let clapCount: Int
    let isClapped: Bool
    let uploadTime: String
    let textImages: [FMPostItem]
    
    static var EMPTY: FMPost = .init(
        id: "",
        user: FMPostUser.EMPTY,
        clapCount: 0,
        isClapped: false,
        uploadTime: "",
        textImages: []
    )
}
