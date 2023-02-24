//
//  UploadImage.swift
//  PIMO
//
//  Created by 양호준 on 2023/02/24.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

struct UploadImage: Identifiable, Equatable {
    let id: Int
    let image: UIImage
    let text: String
    
    init(id: Int, image: UIImage, text: String = "") {
        self.id = id
        self.image = image
        self.text = text
    }
}
