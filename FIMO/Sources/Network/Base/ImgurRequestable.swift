//
//  ImgurRequestable.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/03/25.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

protocol ImgurRequestable: URLRequestConvertible {
    associatedtype Response: Decodable
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
    var header: [HTTPFields: String] { get }
}

extension ImgurRequestable {
    var header: [HTTPFields: String] {
        return [
            HTTPFields.authorization: HTTPHeaderType.imgurClientID.header
        ]
    }

    var baseURL: String {
        guard let imgurURL = Bundle.main.infoDictionary?["ImgurURL"] as? String else {
            return ""
        }

        return imgurURL
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
