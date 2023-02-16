//
//  OnboardingPageType.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/15.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

enum OnboardingPageType: String {
    case one
    case two
    case three
    case four

    var title: String {
        switch self {
        case .one:
            return "프라이빗\n글사진 아카이브,"
        case .two:
            return "사진 속 글귀를 자동 인식해\n텍스트로 복사해보세요"
        case .three:
            return "자동 인식한 사진 속 글귀를\n음성으로 재생해보세요"
        case .four:
            return "초대로 공유하는\n프라이빗 아카이브"
        }
    }

    var body: String {
        switch self {
        case .one:
            return "빠르게 소비하고 지나쳤던 일상에서 마주친 글사진들,\n프라이빗 아카이브 피모에 저장해 언제든지 꺼내보고,\n특별한 지인과 공유해보세요."
        case .two:
            return "피모에는 글이 있는 글사진만 업로드할 수 있어요.\n우리가 똑똑하게 인식한 글사진 속 텍스트를\n버튼 하나로 자유롭게 복사, 공유해보세요."
        case .three:
            return "피모가 인식한 텍스트는 음성으로 변환되어\n소리로 들을 수 있어요. 오디오 버튼을 이용해\n사진 속 문구를 오롯이 감상해보세요."
        case .four:
            return "소중한 글사진을 나만의 아카이브에 저장해보세요.\n링크 공유로 원하는 친구만 초대할 수 있어요.\n친구와 피모를 공유해 서로의 아카이브를 감상해보세요."
        }
    }

    var categoryTitle: String {
        switch self {
        case .one:
            return ""
        case .two:
            return "OCR"
        case .three:
            return "STT"
        case .four:
            return "ARCHIVE"
        }
    }
}

extension OnboardingPageType: Identifiable, CaseIterable {
    var id: String {
        self.rawValue
    }
}
