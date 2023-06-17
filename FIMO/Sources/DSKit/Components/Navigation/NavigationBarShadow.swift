//
//  NavigationBarShadow.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/03/03.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

struct NavigationBarShadow: View {
    var body: some View {
        LinearGradient(
            gradient:
                Gradient(
                    colors: [
                        Color(FIMOAsset.Assets.grayShadow.color).opacity(0.1),
                        Color.clear
                    ]
                ),
            startPoint: .top,
            endPoint: .bottom
        ).frame(height: 10)
    }
}
