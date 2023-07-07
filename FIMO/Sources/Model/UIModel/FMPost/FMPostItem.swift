//
//  FMPostItem.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct FMPostItem {
    let imageUrl: String
    let content: String
}

extension FMPostItem: Hashable, Equatable {
    static let EMPTY: FMPostItem = {
        return .init(imageUrl: "", content: "")
    }()
}
