//
//  Requestable.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

protocol Requestable: URLRequestConvertible {
    associatedtype Response: Decodable
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
}

extension Requestable {
    var header: [HTTPFields: String] {
        return [
            HTTPFields.contentType: HTTPHeaderType.contentType.header
        ]
    }

    var baseURL: String {
        guard let baseURL = Bundle.main.infoDictionary?["BaseURL"] as? String else {
            return ""
        }
        
        return baseURL
    }

    func asURLRequest() throws -> URLRequest {
        let endPoint = try baseURL.asURL()
        var urlRequest = try URLRequest(url: endPoint.appendingPathComponent(path), method: method)

        for headerType in header {
            urlRequest.setValue(headerType.value, forHTTPHeaderField: headerType.key.description)
        }

        switch method {
        case .post, .put, .patch:
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        default:
            return try URLEncoding.default.encode(urlRequest, with: parameters)
        }
    }
}
