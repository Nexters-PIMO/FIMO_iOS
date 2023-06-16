//
//  TrailingItemType.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/03/03.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

enum TrailingItemType {
    case page(Int, Int)
    case none

    @ViewBuilder var view: some View {
        switch self {
        case .page(let pageNumber, let maxPageNumber):
            Text("\(pageNumber)/\(maxPageNumber)")
                .font(Font(FIMOFontFamily.Pretendard.medium.font(size: 16)))
                .foregroundColor(Color(FIMOAsset.Assets.orange.color))
        case .none:
            EmptyView()
        }
    }
}
