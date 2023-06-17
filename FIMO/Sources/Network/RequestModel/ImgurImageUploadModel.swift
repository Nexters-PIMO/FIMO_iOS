//
//  ImgurImageUploadModel.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/03/25.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

enum ImgurImageUploadTarget {
    case upload(Data)
}

struct ImgurImageUploadRequest: ImgurRequestable {
    typealias Response = ImgurImageModel
    let target: ImgurImageUploadTarget

    var path: String {
        switch target {
        case .upload:
            return "/upload"
        }
    }

    var method: HTTPMethod {
        return .post
    }

    var parameters: Parameters = [:]

    var header: [HTTPFields: String] {
        return [
            HTTPFields.authorization: HTTPHeaderType.imgurClientID.header
        ]
    }
}
