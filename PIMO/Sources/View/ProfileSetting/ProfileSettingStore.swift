//
//  ProfileSettingStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/16.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct ProfileSettingStore: ReducerProtocol {
    struct State: Equatable {
        // MARK: 닉네임 설정
        @BindingState var nickname: String = ""
        var nicknameValidationType: NicknameValidationType = .blank
        var isBlackNicknameField: Bool = true
        var isActiveButtonOnNickname: Bool = false

        // MARK: 아카이브 설정
        @BindingState var archiveName: String = ""
        var archiveValidationType: NicknameValidationType = .blank
        var isBlackArchiveField: Bool = true
        var isActiveButtonOnArchive: Bool = false

        // MARK: 프로필 이미지
        @BindingState var isShowImagePicker = false
        var selectedProfileImage: Image?
        var isActiveButtonOnImage: Bool  = false
    }

    enum Action: BindableAction, Equatable {
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

                if isBlack {
                    state.nicknameValidationType = .blank
                } else if isKoreanEnglishAndNumber {
                    state.nicknameValidationType = .onlyKoreanEnglishAndNumber
                } else if nicknameCount > 16 {
                    state.nicknameValidationType = .exceededCharacters
                } else {
                    state.nicknameValidationType = .available
                }

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

                if isBlack {
                    state.archiveValidationType = .blank
                } else if isKoreanEnglishAndNumber {
                    state.archiveValidationType = .onlyKoreanEnglishAndNumber
                } else if archiveCharactorCount > 16 {
                    state.archiveValidationType = .exceededCharacters
                } else {
                    state.archiveValidationType = .available
                }

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
}
