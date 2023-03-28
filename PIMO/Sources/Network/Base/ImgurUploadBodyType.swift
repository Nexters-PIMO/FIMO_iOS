//
//  ImgurUploadBodyType.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/03/25.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

enum ImgurUploadBodyType: String {
    case image
    case url
}

extension ImgurUploadBodyType {
    var withName: String {
        return self.rawValue
    }

    var mimeType: String {
        switch self {
        case .image:
            return "image/jpeg"
        default:
            return ""
        }
    }
}
