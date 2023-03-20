//
//  PopupButtonType.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

enum PopupButtonType {
    case destructive
    case cancel

    var color: Color {
        switch self {
        case .destructive:
            return Color(PIMOAsset.Assets.red1.color)
        case .cancel:
            return Color(PIMOAsset.Assets.grayText.color)
        }
    }
}
