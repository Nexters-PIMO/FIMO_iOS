//
//  DynamicLink.swift
//  FIMO
//
//  Created by 김영인 on 2023/08/27.
//  Copyright © 2023 fimo. All rights reserved.
//

import Foundation

enum DynamicLink {
    case archive(String)
    case post(String, String)
    
    var path: String {
        switch self {
        case .archive:
            return "archive"
            
        case .post:
            return "post"
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case let .archive(userId):
            return ["userId": userId]
            
        case let .post(userId, postId):
            return [
                "userId": userId,
                "postId": postId
            ]
        }
    }
    
    var url: URL? {
        var components = URLComponents(string: "https://www.fimo.com/\(path)?")
        
        if let parameters = parameters {
            components?.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }
        
        return components?.url
    }
}
