//
//  InterceptorAuthenticator.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import Alamofire

class InterceptorAuthenticator: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest

        // TODO: 로그인 정책에 따른 adapt 구현
        request.setValue(HTTPHeaderType.authorization.header, forHTTPHeaderField: HTTPFields.authorization.rawValue)

        completion(.success(request))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }

        // TODO: 로그인 정책에 따른 retry 구현

        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .tokenExpired, object: nil)
        }

        let tokenExpiredError = NetworkError(errorType: .tokenExpired)
        completion(.doNotRetryWithError(tokenExpiredError))
    }
}
