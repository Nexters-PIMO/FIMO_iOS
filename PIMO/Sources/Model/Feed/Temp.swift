//
//  Temp.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/25.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct Temp {
    static let feeds: [Feed] = [
        Feed(id: 1,
             profile: Profile(imageURL: PIMOStrings.profileImage, nickName: "0inn1"),
             uploadTime: "5분 전",
             textImages: [TextImage(id: 1, imageURL: PIMOStrings.textImage, text: "안녕일"),
                          TextImage(id: 2, imageURL: PIMOStrings.textImage, text: "안녕이")],
             clapCount: 310,
             isClapped: false),
        Feed(id: 2,
             profile: Profile(imageURL: PIMOStrings.profileImage, nickName: "0inn2"),
             uploadTime: "10분 전",
             textImages: [TextImage(id: 2, imageURL: PIMOStrings.textImage, text: "안녕삼")],
             clapCount: 320,
             isClapped: true),
        Feed(id: 3,
             profile: Profile(imageURL: PIMOStrings.profileImage, nickName: "0inn3"),
             uploadTime: "10분 전",
             textImages: [TextImage(id: 2, imageURL: PIMOStrings.textImage, text: "안녕사")],
             clapCount: 320,
             isClapped: true)
    ]
    
    static let profile: Profile = Profile(
        imageURL: PIMOStrings.profileImage,
        nickName: "0inn"
    )
}
