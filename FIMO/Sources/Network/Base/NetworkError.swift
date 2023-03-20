//
//  NetworkError.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

struct NetworkError: Error {
    var initialError: AFError?
    let errorType: NetworkErrorType?
}

enum NetworkErrorType {
    case tokenExpired
    case nilValue
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self.errorType {
        case .tokenExpired:
            return "토큰이 만료됐습니다."
        case .nilValue:
            return "값이 존재하지 않습니다."
        default:
            return initialError?.localizedDescription ?? "알 수 없는 에러입니다."
        }
    }
}
