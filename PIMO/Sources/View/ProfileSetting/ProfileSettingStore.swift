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
        // MARK: 닉네임 설정
        @BindingState var nickname: String = ""
        var nicknameValidationType: CheckValidationType = .blank
        var isBlackNicknameField: Bool = true
        var isActiveButtonOnNickname: Bool = false
        var isActiveButton: Bool = false

        // MARK: 아카이브 설정
        @BindingState var archiveName: String = ""
        var archiveValidationType: CheckValidationType = .blank
        var isBlackArchiveField: Bool = true
        var isActiveButtonOnArchive: Bool = false

        // MARK: 프로필 이미지
        @BindingState var isShowImagePicker = false
        var selectedProfileImage: Image?
        var isActiveButtonOnImage: Bool  = false
    }

    enum Action: BindableAction, Equatable, NextButtonActionProtocol {
        case binding(BindingAction<State>)
        case checkDuplicateOnNickName
        case tappedNextButtonOnNickname

        case tappedImagePickerButton
        case checkDuplicateOnArchive
        case tappedNextButtonOnArchive

        case selectProfileImage(Image)
        case tappedCompleteButton
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.$nickname):
                state.isBlackNicknameField = state.nickname == ""
                state.isActiveButtonOnNickname = false

                let isKoreanEnglishAndNumber = !state.nickname.match(for: "^[가-힣a-zA-Z0-9]+$")
                let isBlack = state.nickname == ""
                let nicknameCount = state.nickname.replacingOccurrences(of: "[가-힣]", with: "00", options: .regularExpression)
                    .count

                state.nicknameValidationType = checkValidation(isMatchCharactors: isKoreanEnglishAndNumber,
                                                              isBlack: isBlack,
                                                              charactorCount: nicknameCount)

                return .none
            case .checkDuplicateOnNickName:
                #warning("중복 확인 네트워크 연결 필요")
                state.isActiveButtonOnNickname = state.nicknameValidationType == .available

                return .none
            case .tappedNextButtonOnNickname:
                #warning("네비게이션 적용")

                return .none
            case .binding(\.$archiveName):
                state.isBlackArchiveField = state.archiveName == ""
                state.isActiveButtonOnArchive = false

                let isKoreanEnglishAndNumber = !state.archiveName.match(for: "^[가-힣a-zA-Z0-9\\s]+$")
                let isBlack = state.archiveName == ""
                let archiveCharactorCount = state.archiveName.replacingOccurrences(of: "[가-힣]", with: "00", options: .regularExpression)
                    .count

                state.archiveValidationType = checkValidation(isMatchCharactors: isKoreanEnglishAndNumber,
                                                              isBlack: isBlack,
                                                              charactorCount: archiveCharactorCount)

                return .none
            case .checkDuplicateOnArchive:
                #warning("중복 확인 네트워크 연결 필요")
                state.isActiveButtonOnArchive = state.archiveValidationType == .available

                return .none
            case .tappedNextButtonOnArchive:
                #warning("네비게이션 적용")

                return .none
            case .tappedImagePickerButton:
                state.isShowImagePicker = true

                return .none
            case .selectProfileImage(let image):
                state.selectedProfileImage = image
                state.isActiveButtonOnImage = true

                return .none
            default:
                return .none
            }
        }
    }

    private func checkValidation(isMatchCharactors: Bool,
                                 isBlack: Bool,
                                 charactorCount: Int) -> CheckValidationType {
        if isBlack {
            return .blank
        } else if isMatchCharactors {
            return .onlyKoreanEnglishAndNumber
        } else if charactorCount > 16 {
            return .exceededCharacters
        } else {
            return .available
        }
    }
}
