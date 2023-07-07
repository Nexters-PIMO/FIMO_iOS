//
//  FMPost.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct FMPost {
    let id: String
    let user: FMPostUser
    let favorite: Int
    let isClicked: Bool
    let createdAt: String
    let items: [FMPostItem]
}

extension FMPost: Hashable, Equatable {
    static let EMPTY: FMPost = {
        return .init(
            id: "",
            user: .init(
                id: "",
                nickname: "",
                archiveName: ""
            ),
            favorite: 0,
            isClicked: false,
            createdAt: "",
            items: [FMPostItem]()
        )
    }()
}
