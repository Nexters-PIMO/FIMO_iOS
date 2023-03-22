//
//  BaseNetwork.swift
//  PIMO
//
//  Created by 김영인 on 2023/01/20.
//  Copyright © 2023 PIMO. All rights reserved.
//

import Combine
import Foundation

import Alamofire

protocol BaseNetworkInterface {
    func request<API: Requestable>(api: API, isInterceptive: Bool) -> AnyPublisher<API.Response, NetworkError>
}

struct BaseNetwork: BaseNetworkInterface {
    private let decoder = JSONDecoder()
    private let session: Session
    private let interceptorAuthenticator: RequestInterceptor

    static let shared: BaseNetworkInterface = BaseNetwork()
    static let decoder: JSONDecoder = JSONDecoder()

    private init(interceptorAuthenticator: RequestInterceptor = InterceptorAuthenticator()) {
        self.interceptorAuthenticator = interceptorAuthenticator

        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 10
        configuration.waitsForConnectivity = true
        self.session = Session(configuration: configuration)
    }

    func request<API: Requestable>(api: API, isInterceptive: Bool) -> AnyPublisher<API.Response, NetworkError> {
        session.request(api, interceptor: isInterceptive ? interceptorAuthenticator : nil)
            .validate(statusCode: 200..<500)
            .publishData()
            .tryMap({
                print("----------------------------------- 🌐 Network LOG -----------------------------------\n")
                print("URL: \(api.baseURL + api.path)\nmethod: \(api.method)\nheader: \(api.header)\nresult: \($0.result)\n")
                
                guard let responseData = $0.value,
                      let json = try JSONSerialization.jsonObject(with: responseData) as? [String: Any],
                      let status = json["status"] as? String,
                      let message = json["message"] as? String,
                      let dataJson = json["data"] else {
                    throw NetworkError(errorType: .unknown)
                }

                guard status == "OK" else {
                    throw NetworkError(errorType: .serverError(message))
                }
                
                guard JSONSerialization.isValidJSONObject(dataJson),
                      let data = try? JSONSerialization.data(withJSONObject: dataJson),
                      let value = try? BaseNetwork.decoder.decode(API.Response.self, from: data) else {
                    print("❌ Fail\n decodingError")
                    throw NetworkError(errorType: .decodingError)
                }

                print("🚀 Success\ndata: \(value)\n")
                
                return value
            })
            .mapError({ error in
                error as? NetworkError ?? .init(errorType: .unknown)
            })
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
