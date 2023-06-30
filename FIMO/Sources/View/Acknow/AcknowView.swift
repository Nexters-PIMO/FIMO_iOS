//
//  AcknowView.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/03/18.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

struct AcknowView: View {
    var body: some View {
        VStack {
            CustomNavigationBar(title: "오픈소스 라이선스", isShadowed: true)

            AcknowListView()
                .toolbar(.hidden, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
