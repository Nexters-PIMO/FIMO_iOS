//
//  NicnameValidationType.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/17.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

enum CheckValidationType: String {
    case availableNickName
    case availableArchiveName
    case onlyKoreanEnglishAndNumber
    case exceededCharacters
    case blank
    case sameName
    case beforeDuplicateCheck
    case alreadyUsedNickname
    case alreadyUsedArchiveName
}

extension CheckValidationType: CustomStringConvertible {
    var description: String {
        switch self {
        case .availableNickName:
            return "사용할 수 있는 닉네임이에요"
        case .availableArchiveName:
            return "사용할 수 있는 이름이에요"
        case .onlyKoreanEnglishAndNumber:
            return "한글과 영어, 숫자만 사용할 수 있어요"
        case .exceededCharacters:
            return "글자 수를 초과했어요"
        case .blank, .beforeDuplicateCheck, .sameName:
            return ""
        case .alreadyUsedNickname:
            return "이미 사용 중인 닉네임이에요"
        case .alreadyUsedArchiveName:
            return "이미 사용 중인 이름이에요"
        }
    }

    var isDuplicateButtonEnabled: Bool {
        switch self {
        case .beforeDuplicateCheck, .availableNickName, .availableArchiveName:
            return true
        default:
            return false
        }
    }

    var isBlankField: Bool {
        return self == .blank
    }

    var isOKButtonClickable: Bool {
        switch self {
        case .availableNickName, .availableArchiveName:
            return true
        default:
            return false
        }
    }

    var fieldColor: Color {
        switch self {
        case .blank:
            return Color(FIMOAsset.Assets.gray1.color)
        default:
            return Color.black
        }
    }

    var duplicatedButtonColor: Color {
        switch self {
        case .beforeDuplicateCheck, .availableNickName, .availableArchiveName:
            return Color.black
        default:
            return Color(FIMOAsset.Assets.gray1.color)
        }
    }

    var descriptionColor: Color {
        switch self {
        case .alreadyUsedNickname, .exceededCharacters, .onlyKoreanEnglishAndNumber:
            return Color(FIMOAsset.Assets.red1.color)
        default:
            return Color.black
        }
    }
}
