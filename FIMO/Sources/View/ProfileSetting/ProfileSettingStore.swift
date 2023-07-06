//
//  ProfileSettingStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/16.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

protocol NextButtonStateProtocol {
    var isActiveButton: Bool { get set }
}

protocol NextButtonActionProtocol {
    static var tappedNextButtonOnNickname: Self { get }
}

struct ProfileSettingStore: ReducerProtocol {
    struct State: Equatable, NextButtonStateProtocol {
        @BindingState var isShowToast: Bool = false
        var toastMessage: ToastModel = ToastModel(title: FIMOStrings.textCopyToastTitle,
                                                  message: FIMOStrings.textCopyToastMessage)

        // 회원가입 제출용 유저 식별자
        var userId: String = ""

        // MARK: 닉네임 설정
        @BindingState var nickname: String = ""
        var previousNickname: String?
        var nicknameValidationType: CheckValidationType = .blank
        var isActiveButtonOnNickname: Bool = false
        var isActiveButton: Bool = false

        // MARK: 아카이브 설정
        @BindingState var archiveName: String = ""
        var previousArchiveName: String?
        var archiveValidationType: CheckValidationType = .blank
        var isActiveButtonOnArchive: Bool = false

        // MARK: 프로필 이미지
        @BindingState var isShowImagePicker = false
        var selectedProfileImage: UIImage?
        var selectedImageURL: String?
        var previousSelectedImageURL: String?
        var isActiveButtonOnImage: Bool = false

        // MARK: 프로필 수정 관련 프로퍼티
        var isModifiedInfo: Bool {
            return nickname != previousNickname
            || archiveName != previousArchiveName
            || selectedImageURL != previousSelectedImageURL
        }

        var isUnchangedNickname: Bool {
            return nickname == previousNickname
        }

        var isUnchangedArchiveName: Bool {
            return archiveName == previousArchiveName
        }
    }

    enum Action: BindableAction, Equatable, NextButtonActionProtocol {
        case binding(BindingAction<State>)
        case onAppear
        case sendToast(ToastModel)
        case sendToastDone
        case checkNicknameValidationType
        case checkDuplicateOnNickName
        case checkDuplicateOnNickNameDone(Result<Bool, NetworkError>)
        case tappedNextButtonOnNickname

        case tappedImagePickerButton
        case checkArchiveValidationType
        case checkDuplicateOnArchive
        case checkDuplicateOnArchiveNameDone(Result<Bool, NetworkError>)
        case tappedNextButtonOnArchive

        case selectProfileImage(UIImage)
        case fetchImageURL
        case fetchImageURLDone(Result<ImgurImageModel, NetworkError>)
        case signUpOnProfilePicture
        case signUpDone(Result<FMServerDescriptionDTO, NetworkError>)

        case tappedCompleteButton

        case tappedCompleteModifyButton
        case modifyProfileDone(Result<FMProfileDTO, NetworkError>)
        case tappedBackButton

        case acceptBack
    }

    @Dependency(\.imgurImageClient) var imgurImageClient
    @Dependency(\.profileClient) var profileClient

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                let effects: [EffectTask<ProfileSettingStore.Action>] = [
                    .init(value: .checkNicknameValidationType),
                    .init(value: .checkArchiveValidationType)
                ]
                return .merge(effects)
            case let .sendToast(toastModel):
                if state.isShowToast {
                    return EffectTask<Action>(value: .sendToast(toastModel))
                        .delay(for: .milliseconds(1000), scheduler: DispatchQueue.main)
                        .eraseToEffect()
                } else {
                    state.isShowToast = true
                    state.toastMessage = toastModel
                    return EffectTask<Action>(value: .sendToastDone)
                        .delay(for: .milliseconds(2000), scheduler: DispatchQueue.main)
                        .eraseToEffect()
                }
            case .sendToastDone:
                state.isShowToast = false
                return .none
            case .binding(\.$nickname):
                return .init(value: .checkNicknameValidationType)
            case .checkNicknameValidationType:
                if state.isUnchangedNickname && state.nicknameValidationType == .availableNickName {
                    return .none
                }

                state.isActiveButtonOnNickname = state.nicknameValidationType == .availableNickName

                let isExcludeKoreanEnglishAndNumber = !state.nickname.match(for: "^[가-힣a-zA-Z0-9]+$")
                let isBlack = state.nickname == ""
                let nicknameCount = state.nickname.replacingOccurrences(of: "[가-힣]", with: "00", options: .regularExpression)
                    .count

                state.nicknameValidationType = checkValidationOnTyping(isExcludeCharactors: isExcludeKoreanEnglishAndNumber,
                                                                       isBlack: isBlack,
                                                                       charactorCount: nicknameCount,
                                                                       isModifiedInfo: state.isModifiedInfo,
                                                                       isSameName: state.isUnchangedNickname)
                return .none
            case .checkDuplicateOnNickName:
                return profileClient.isExistsNickname(state.nickname)
                    .map {
                        Action.checkDuplicateOnNickNameDone($0)
                    }
            case .checkDuplicateOnNickNameDone(let result):
                switch result {
                case .success(let isValidNickname):
                    state.nicknameValidationType = isValidNickname
                    ? .availableNickName
                    : .alreadyUsedNickname

                    state.isActiveButtonOnNickname = state.nicknameValidationType == .availableNickName
                    state.previousNickname = state.nickname
                case .failure(let error):
                    state.toastMessage = .init(title: error.errorDescription ?? "")
                    state.isShowToast = true
                }
                return .none
            case .binding(\.$archiveName):
                return .init(value: .checkArchiveValidationType)
            case .checkArchiveValidationType:
                if state.isUnchangedArchiveName && state.archiveValidationType == .availableArchiveName {
                    return .none
                }

                state.isActiveButtonOnArchive = state.archiveValidationType == .availableArchiveName

                let isExcludeKoreanAndEnglish = !state.archiveName.match(for: "^[가-힣a-zA-Z0-9\\s]+$")
                let isBlack = state.archiveName == ""
                let archiveCharactorCount = state.archiveName.replacingOccurrences(of: "[가-힣]", with: "00", options: .regularExpression)
                    .count

                state.archiveValidationType = checkValidationOnTyping(isExcludeCharactors: isExcludeKoreanAndEnglish,
                                                                      isBlack: isBlack,
                                                                      charactorCount: archiveCharactorCount,
                                                                      isModifiedInfo: state.isModifiedInfo,
                                                                      isSameName: state.isUnchangedArchiveName)

                return .none
            case .checkDuplicateOnArchive:
                guard state.archiveValidationType == .beforeDuplicateCheck else {
                    return .none
                }

                return profileClient.isExistsArchiveName(state.archiveName)
                    .map {
                        Action.checkDuplicateOnArchiveNameDone($0)
                    }
            case .checkDuplicateOnArchiveNameDone(let result):
                switch result {
                case .success(let isValidArchiveName):
                    state.archiveValidationType = isValidArchiveName
                    ? .availableArchiveName
                    : .alreadyUsedArchiveName

                    state.isActiveButtonOnArchive = state.archiveValidationType == .availableArchiveName
                    state.previousArchiveName = state.archiveName
                case .failure(let error):
                    state.toastMessage = .init(title: error.errorDescription ?? "")
                    state.isShowToast = true
                }
                return .none
            case .tappedImagePickerButton:
                state.isShowImagePicker = true
                return .none
            case .selectProfileImage(let image):
                state.selectedProfileImage = image

                return .init(value: Action.fetchImageURL)
            case .fetchImageURL:
                return imgurImageClient
                    .uploadImage(state.selectedProfileImage?.jpegData(compressionQuality: 0.9) ?? Data())
                    .map {
                        Action.fetchImageURLDone($0)
                    }
            case .fetchImageURLDone(let result):
                switch result {
                case .success(let imageModel):
                    state.selectedImageURL = imageModel.link
                    state.isActiveButtonOnImage = true
                    
                    return .none
                case .failure(let error):
                    state.toastMessage = .init(title: error.errorDescription ?? "")
                    state.isShowToast = true
                    return .none
                }
            case .tappedCompleteModifyButton:
                let result = profileClient.updateProfile(
                    state.nickname,
                    state.archiveName,
                    state.selectedImageURL ?? ""
                )

                return result.map {
                    Action.modifyProfileDone($0)
                }
            case .signUpOnProfilePicture:
                guard let imageURL = state.selectedImageURL else {
                    Log.error("이미지 URL이 없습니다.")
                    return .none
                }

                let signUpModel = FMSignUp(
                    identifier: state.userId,
                    nickname: state.nickname,
                    archiveName: state.archiveName,
                    profileImageUrl: imageURL
                )

                let signupResult = profileClient.signUp(signUpModel)

                return signupResult.map {
                    Action.signUpDone($0)
                }
            default:
                return .none
            }
        }
    }

    private func checkValidationOnTyping(isExcludeCharactors: Bool,
                                         isBlack: Bool,
                                         charactorCount: Int,
                                         isModifiedInfo: Bool,
                                         isSameName: Bool) -> CheckValidationType {
        if isBlack {
            return .blank
        } else if isExcludeCharactors {
            return .onlyKoreanEnglishAndNumber
        } else if charactorCount > 16 {
            return .exceededCharacters
        } else if isSameName {
            return .sameName
        } else if isModifiedInfo {
            return .beforeDuplicateCheck
        } else {
            return .availableNickName
        }
    }
}
