//
//  ImgurImageClient.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/03/25.
//  Copyright © 2023 pimo. All rights reserved.
//

import Combine
import Foundation

import ComposableArchitecture

struct ImgurImageClient {
    let uploadImage: (Data) -> EffectPublisher<Result<ImgurImageModel, NetworkError>, Never>
}

extension DependencyValues {
    var imgurImageClient: ImgurImageClient {
        get { self[ImgurImageClient.self] }
        set { self[ImgurImageClient.self] = newValue }
    }
}

extension ImgurImageClient: DependencyKey {
    static let liveValue = Self.init { data in
        let request = ImgurImageUploadRequest(target: .upload(data))

        return BaseNetwork.shared.uploadImage(api: request, imageData: data)
            .catchToEffect()
    }}
