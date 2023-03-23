//
//  FeedDTO.swift
//  PIMO
//
//  Created by 김영인 on 2023/03/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct FeedDTO: Decodable, Equatable {
    let id: Int
    let userId: String
    let status: String
    let createdAt: String
    let clapCount: Int
    let clapped: Bool
    let contents: [TextImageDTO]
    
    func toModel() -> Feed {
        return Feed(
            id: self.id,
            userId: self.userId,
            uploadTime: self.createdAt.toUploadTime(),
            textImages: self.contents.map { $0.toModel() },
            clapCount: self.clapCount,
            isClapped: self.clapped
        )
    }
}
