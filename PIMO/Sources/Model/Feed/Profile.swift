//
//  Profile.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/18.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct Profile: Decodable, Equatable {
    let imageURL: String
    let nickName: String
    
    init(imageURL: String = "", nickName: String = "") {
        self.imageURL = imageURL
        self.nickName = nickName
    }
}
