//
//  UserDTO.swift
//  PIMO
//
//  Created by 김영인 on 2023/03/29.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct UserDTO: Decodable, Equatable {
    let userId: String
    let nickName: String
    let profileImgUrl: String
    
    func toModel() -> User {
        return User(
            userId: self.userId,
            nickName: self.nickName,
            profileImage: self.profileImgUrl
        )
    }
}
