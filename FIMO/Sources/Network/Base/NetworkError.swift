//
//  NetworkError.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

struct NetworkError: Error, Equatable {
    let errorType: NetworkErrorType?
}

enum NetworkErrorType: Equatable {
    case tokenExpired
    case nilValue
    case decodingError
    case serverError(ServerErrorType)
    case imgurError(String)
    case unknownType
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self.errorType {
        case .tokenExpired:
            return "토큰이 만료됐습니다."
        case .nilValue:
            return "값이 존재하지 않습니다."
        case .decodingError:
            return "디코딩 에러"
        case .serverError(let serverErrorType):
            return serverErrorType.rawValue
        case .imgurError(let errorDescription):
            return errorDescription
        case .unknownType:
            return "알 수 없는 타입입니다"
        default:
            return "알 수 없는 에러입니다."
        }
    }
}

enum ServerErrorType: String {
    case userNotFound = "USER_NOT_FOUND"
    case userAlreadyExist = "USER_ALREADY_EXIST"
    case unknown
}

extension ServerErrorType: CustomStringConvertible {
    var description: String {
        return self.rawValue
    }
}
