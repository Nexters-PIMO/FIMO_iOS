//
//  PIMODivier.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

struct CustomDivider: View {
    private var weight: CGFloat = 1

    init(weight: CGFloat = 1) {
        self.weight = weight
    }

    var body: some View {
        Rectangle()
            .frame(width: .infinity, height: weight)
            .foregroundColor(Color(FIMOAsset.Assets.gray2.color))
    }
}

struct PIMODivier_Previews: PreviewProvider {
    static var previews: some View {
        CustomDivider(weight: 1)
    }
}
