//
//  HomeWelcomeView.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/18.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

extension HomeView {
    @ViewBuilder
    var homeWelcome: some View {
        Spacer()
        
        VStack {
            HStack {
                Image(uiImage: PIMOAsset.Assets.fimoText.image)
                
                Text(PIMOStrings.welcome)
                    .font(.system(size: 19, weight: .medium))
            }
            
            Spacer()
                .frame(height: 18)
            
            Text(PIMOStrings.welcomeGuide)
                .foregroundColor(Color(PIMOAsset.Assets.grayText.color))
                .font(.system(size: 14, weight: .light))
                .multilineTextAlignment(.center)
            
            Spacer()
                .frame(height: 25)
            
            Image(uiImage: PIMOAsset.Assets.homeWelcome.image)
                .shadow(radius: 5)
        }
        
        Spacer()
    }
}
