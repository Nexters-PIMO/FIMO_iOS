//
//  UploadImage.swift
//  PIMO
//
//  Created by 양호준 on 2023/02/24.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

struct UploadImage {
    var id: Int
    let image: UIImage
    let text: String
    var imageUrl: String?
    
    init(id: Int, image: UIImage, text: String = "") {
        self.id = id
        self.image = image
        self.text = text
        self.imageUrl = nil
    }
}

extension UploadImage: Identifiable, Equatable {
    func toUpdatedPostItem() -> FMUpdatedPostItem {
        guard let imageUrl = imageUrl else {
            Log.error("이미지 URL이 누락되어 있습니다. \(id)")
            return .init(imageUrl: "", content: text)
        }

        return .init(imageUrl: imageUrl, content: text)
    }
}
