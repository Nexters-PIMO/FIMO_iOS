//
//  FMPostItem.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct FMPostItem: Equatable, Hashable {
    let imageURL: String
    let text: String
    
    static var EMPTY: FMPostItem = .init(
        imageURL: "",
        text: ""
    )
}
