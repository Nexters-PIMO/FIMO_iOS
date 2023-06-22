//
//  FMPost.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct FMPost: Equatable {
    let id: String
    let user: FMPostUser
    let favorite: Int
    let isClicked: Bool
    let createdAt: String
    let items: [FMPostItem]
}
