//
//  ArchiveInfo.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/25.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct ArchiveInfo: Equatable {
    let friendType: FrinedType
    let archiveName: String
    let profile: Profile
    let feedCount: Int
    
    static var EMPTY: ArchiveInfo = ArchiveInfo(
        friendType: .neither,
        archiveName: "",
        profile: Profile.EMPTY,
        feedCount: 0
    )
}
