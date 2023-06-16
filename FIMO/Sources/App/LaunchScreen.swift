//
//  LaunchScreen.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/03/03.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        ZStack(alignment: .center) {
            Color(FIMOAsset.Assets.orange.color)
                .ignoresSafeArea()

            Image(uiImage: FIMOAsset.Assets.launchScreenLogo.image)
                .padding(.bottom, 30)
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
