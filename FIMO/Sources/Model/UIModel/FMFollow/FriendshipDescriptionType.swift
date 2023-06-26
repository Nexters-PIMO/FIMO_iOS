//
//  FriendshipDescriptionType.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/26.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

enum FriendshipDescriptionType: String {
    case follow
    case unfollow
}

extension FriendshipDescriptionType {
    var okButtonDescription: String {
        switch self {
        case .follow:
            return "친구신청"
        case .unfollow:
            return "친구끊기"
        }
    }
}
