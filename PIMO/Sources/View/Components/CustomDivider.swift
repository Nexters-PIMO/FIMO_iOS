//
//  PIMODivier.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

struct CustomDivider: View {
    var weight: CGFloat = 1

    var body: some View {
        Rectangle()
            .frame(width: .infinity, height: weight)
            .foregroundColor(Color(PIMOAsset.Assets.gray2.color))
    }
}

struct PIMODivier_Previews: PreviewProvider {
    static var previews: some View {
        CustomDivider(weight: 1)
    }
}
