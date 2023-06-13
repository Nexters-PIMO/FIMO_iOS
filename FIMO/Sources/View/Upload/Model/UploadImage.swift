//
//  UploadImage.swift
//  PIMO
//
//  Created by 양호준 on 2023/02/24.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

final class UploadImage: Identifiable, Equatable {
    var id: Int
    let image: UIImage
    let text: String
    
    init(id: Int, image: UIImage, text: String = "") {
        self.id = id
        self.image = image
        self.text = text
    }
    
    static func == (lhs: UploadImage, rhs: UploadImage) -> Bool {
        lhs.id == rhs.id
    }
}
