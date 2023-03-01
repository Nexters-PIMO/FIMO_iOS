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
             profile: Profile(imageURL: PIMOStrings.otherProfileImage, nickName: "EOEUNOO"),
             uploadTime: "5분 전",
             textImages: [TextImage(id: 1, imageURL: PIMOStrings.textImage, text: "옳은 일을 하는 것은 결코 잘못이 아니다"),
                          TextImage(id: 2, imageURL: PIMOStrings.textImage2, text: "음악 소리가 안들린다. 보고타 축 쳐져서 일할 거야? 음악 어디 갔어?")],
             clapCount: 310,
             isClapped: false),
        Feed(id: 2,
             profile: Profile(imageURL: PIMOStrings.profileImage, nickName: "CHERISHER_Y"),
             uploadTime: "10분 전",
             textImages: [TextImage(id: 3, imageURL: PIMOStrings.textImage2, text: "음악 소리가 안들린다. 보고타 축 쳐져서 일할 거야? 음악 어디 갔어?")],
             clapCount: 320,
             isClapped: true),
        Feed(id: 3,
             profile: Profile(imageURL: PIMOStrings.profileImage, nickName: "0inn"),
             uploadTime: "30분 전",
             textImages: [TextImage(id: 4, imageURL: PIMOStrings.textImage, text: "옳은 일을 하는 것은 결코 잘못이 아니다")],
             clapCount: 320,
             isClapped: true),
        Feed(id: 4,
             profile: Profile(imageURL: PIMOStrings.profileImage, nickName: "0inn"),
             uploadTime: "힌 시간 전",
             textImages: [TextImage(id: 5, imageURL: PIMOStrings.textImage2, text: "음악 소리가 안들린다. 보고타 축 쳐져서 일할 거야? 음악 어디 갔어?")],
             clapCount: 320,
             isClapped: true)
    ]
    
    static let myFeeds: [Feed] = [
        Feed(id: 3,
             profile: Profile(imageURL: PIMOStrings.profileImage, nickName: "0inn"),
             uploadTime: "30분 전",
             textImages: [TextImage(id: 3, imageURL: PIMOStrings.textImage, text: "옳은 일을 하는 것은 결코 잘못이 아니다")],
             clapCount: 320,
             isClapped: true),
        Feed(id: 4,
             profile: Profile(imageURL: PIMOStrings.profileImage, nickName: "0inn"),
             uploadTime: "힌 시간 전",
             textImages: [TextImage(id: 5, imageURL: PIMOStrings.textImage2, text: "음악 소리가 안들린다. 보고타 축 쳐져서 일할 거야? 음악 어디 갔어?")],
             clapCount: 320,
             isClapped: true)
    ]
    
    static let profile: Profile = Profile(
        imageURL: PIMOStrings.profileImage,
        nickName: "0inn"
    )
    
    static let otherProfile: Profile = Profile(
        imageURL: PIMOStrings.otherProfileImage,
        nickName: "EOEUNOO"
    )
}
