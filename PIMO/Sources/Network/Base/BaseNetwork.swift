//
//  BaseNetwork.swift
//  PIMO
//
//  Created by 김영인 on 2023/01/20.
//  Copyright © 2023 PIMO. All rights reserved.
//

import Foundation
import Combine

import Alamofire

protocol BaseNetworkInterface {
    func request<API: Requestable>(api: API, isInterceptive: Bool) -> AnyPublisher<API.Response, Error>
}

struct BaseNetwork: BaseNetworkInterface {
    private let decoder = JSONDecoder()
    private let session: Session
    private let interceptorAuthenticator: RequestInterceptor

    static let shared: BaseNetworkInterface = BaseNetwork()

    private init(interceptorAuthenticator: RequestInterceptor = InterceptorAuthenticator()) {
        self.interceptorAuthenticator = interceptorAuthenticator

        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 10
        configuration.waitsForConnectivity = true
        self.session = Session(configuration: configuration)
    }

    func request<API: Requestable>(api: API, isInterceptive: Bool) -> AnyPublisher<API.Response, Error> {
        session.request(api, interceptor: isInterceptive ? interceptorAuthenticator : nil)
            .validate(statusCode: 200..<500)
            .publishDecodable(type: API.Response.self)
            .tryMap({
                guard let value = $0.value else {
                    throw NetworkError.init(initialError: $0.error, errorType: .nilValue)
                }

                return value
            })
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
