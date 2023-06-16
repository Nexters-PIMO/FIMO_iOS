//
//  View+.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/18.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

extension View {
    
    /// isHidden 파라미터에 Bool 타입 넣어서 해당 뷰 Hidden 처리할지 결정하는 메서드
    @ViewBuilder func isHidden(_ hidden: Bool) -> some View {
        if hidden {
            self.hidden()
        } else {
            self
        }
    }
}
