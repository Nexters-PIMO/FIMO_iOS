//
//  ToastType.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

enum ToastType {
    case completeCopy
    case completeProfileSetting
    case noExistPhoto

    var title: String {
        switch self {
        case .completeCopy:
            return "글 사진 텍스트 복사 완료!"
        case .completeProfileSetting:
            return "프로필 수정이 완료되었어요!"
        case .noExistPhoto:
            return "글이 존재하지 않는 사진이에요!"
        }
    }

    var message: String? {
        switch self {
        case .completeCopy:
            return "글 사진 속 텍스트를 지인들에게 공유해보세요."
        case .completeProfileSetting:
            return nil
        case .noExistPhoto:
            return "글이 포함되어 있는 사진으로 업로드해주세요."
        }
    }
}
