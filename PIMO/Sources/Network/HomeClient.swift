//
//  HomeService.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/26.
//  Copyright © 2023 pimo. All rights reserved.
//

import Combine
import Foundation

import ComposableArchitecture

struct HomeClient {
    let fetchFeeds: () -> [Feed]
}

extension DependencyValues {
    var homeClient: HomeClient {
        get { self[HomeClient.self] }
        set { self[HomeClient.self] = newValue }
    }
}

extension HomeClient: DependencyKey {
    static let liveValue = Self.init (
        fetchFeeds: {
            // TODO: 서버 통신
            return [Feed(id: 1,
                         profile: Profile(imageURL: PIMOStrings.profileImage, nickName: "0inn1"),
                         uploadTime: "5분 전",
                         textImages: [TextImage(id: 1, imageURL: PIMOStrings.textImage, text: "안녕"),
                                      TextImage(id: 2, imageURL: PIMOStrings.textImage, text: "안녕")],
                         clapCount: 310,
                         isClapped: false),
                    Feed(id: 2,
                         profile: Profile(imageURL: PIMOStrings.profileImage, nickName: "0inn2"),
                         uploadTime: "10분 전",
                         textImages: [TextImage(id: 2, imageURL: PIMOStrings.textImage, text: "안녕")],
                         clapCount: 320,
                         isClapped: true)]
        }
    )
}
