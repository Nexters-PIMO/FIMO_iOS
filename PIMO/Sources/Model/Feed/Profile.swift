//
//  Profile.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/18.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct Profile: Decodable, Equatable, Hashable {
    let imageURL: String
    let nickName: String
    
    static var EMPTY: Profile = .init(imageURL: "", nickName: "")
}
