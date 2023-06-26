//
//  ProfileClient.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/18.
//  Copyright © 2023 pimo. All rights reserved.
//

import Combine
import Foundation

import ComposableArchitecture

struct ProfileClient {
    let fetchMyProfile: () -> EffectTask<Result<Profile, NetworkError>>
    let saveProfile: ((nickname: String, archiveName: String, profileImgURL: String)) -> EffectTask<Result<Profile, NetworkError>>
    let deleteProfile: () -> EffectTask<Result<Bool, NetworkError>>
    let fetchIsExistsNickname: (String) -> EffectTask<Result<Bool, NetworkError>>
    let fetchIsExistsArchiveName: (String) -> EffectTask<Result<Bool, NetworkError>>
    let patchNickname: (String) -> EffectTask<Result<Profile, NetworkError>>
    let patchArchiveName: (String) -> EffectTask<Result<Profile, NetworkError>>
    let patchProfileImage: (String) -> EffectTask<Result<Profile, NetworkError>>

    // 새로운 API 적용
    let isExistsNickname: (String) -> EffectTask<Result<Bool, NetworkError>>
    let isExistsArchiveName: (String) -> EffectTask<Result<Bool, NetworkError>>
    let signUp: (FMSignUp) -> EffectTask<Result<FMServerDescriptionDTO, NetworkError>>
    let myProfile: () -> EffectTask<Result<FMProfileDTO, NetworkError>>
}

extension DependencyValues {
    var profileClient: ProfileClient {
        get { self[ProfileClient.self] }
        set { self[ProfileClient.self] = newValue }
    }
}

extension ProfileClient: DependencyKey {
    static let liveValue = Self.init {
        let request = ProfileRequest(target: .fetchMyProfile)

        return BaseNetwork.shared.request(api: request, isInterceptive: true)
            .catchToEffect()
    } saveProfile: { (nickname, archiveName, profileImageURL) in
        let request = ProfileRequest(target: .saveProfile(nickname: nickname, archiveName: archiveName, profileImgURL: profileImageURL))

        return BaseNetwork.shared.request(api: request, isInterceptive: true)
            .catchToEffect()
    } deleteProfile: {
        let request = ProfileCheckRequest(target: .deleteProfile)

        return BaseNetwork.shared.requestWithNoResponse(api: request, isInterceptive: true)
            .catchToEffect()
    } fetchIsExistsNickname: { nickname in
        let request = ProfileCheckRequest(target: .fetchIsExistsNickname(nickname))

        return BaseNetwork.shared.requestWithNoResponse(api: request, isInterceptive: true)
            .catchToEffect()
    } fetchIsExistsArchiveName: { archiveName in
        let request = ProfileCheckRequest(target: .fetchIsExistsArchiveName(archiveName))

        return BaseNetwork.shared.requestWithNoResponse(api: request, isInterceptive: true)
            .catchToEffect()
    } patchNickname: { nickname in
        let request = ProfileRequest(target: .patchNickname(nickname: nickname))

        return BaseNetwork.shared.request(api: request, isInterceptive: true)
            .catchToEffect()
    } patchArchiveName: { archiveName in
        let request = ProfileRequest(target: .patchArchiveName(archiveName: archiveName))

        return BaseNetwork.shared.request(api: request, isInterceptive: true)
            .catchToEffect()
    } patchProfileImage: { profileImageURL in
        let request = ProfileRequest(target: .patchprofileImage(profilImageURL: profileImageURL))

        return BaseNetwork.shared.request(api: request, isInterceptive: true)
            .catchToEffect()
    } isExistsNickname: { nickname in
        let request = FMUserValidateRequest(target: .nickname(name: nickname))

        return BaseNetwork.shared.request(api: request, isInterceptive: true)
            .catchToEffect()
    } isExistsArchiveName: { archiveName in
        let request = FMUserValidateRequest(target: .archive(name: archiveName))

        return BaseNetwork.shared.request(api: request, isInterceptive: true)
            .catchToEffect()
    } signUp: { signUpModel in
        let request = FMSignUpRequest(signUpModel: signUpModel)

        return BaseNetwork.shared.request(api: request, isInterceptive: true)
            .catchToEffect()
    } myProfile: {
        let request = FMMyProfileRequest()

        return BaseNetwork.shared.request(api: request, isInterceptive: true)
            .catchToEffect()
    }

}
