//
//  TabBar.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/13.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

enum TabBarItem: CaseIterable {
    case home
    case upload
    case myFeed
}

struct TabBar: View {
    @Binding var selected: TabBarItem
    
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                Spacer()
                    .frame(width: 60)
                
                Image(uiImage: PIMOAsset.Assets.home.image)
                    .frame(width: 28, height: 28)
                
                Spacer()
                
                Image(uiImage: PIMOAsset.Assets.example.image)
                    .frame(width: 28, height: 28)
                    .cornerRadius(14)
                    .overlay(Circle().stroke(Color.black, lineWidth: 1.5))
                
                Spacer()
                    .frame(width: 60)
            }
            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 72)
            .background(Color(PIMOAsset.Assets.gray.color))
            .cornerRadius(20, corners: [.topLeft, .topRight])
            
            ZStack {
                Circle()
                    .frame(width: 72, height: 72)
                
                Image(uiImage: PIMOAsset.Assets.plus.image)
                    .frame(width: 24, height: 24)
            }
            .offset(x: 0, y: -36)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .edgesIgnoringSafeArea(.bottom)
    }
}
