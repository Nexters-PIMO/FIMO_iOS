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
    case myFeed
}

struct TabBar: View {
    @Binding var selected: TabBarItem
    
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                Spacer()
                    .frame(width: 60)
                
                HomeTabBar(isSelected: selected == .home)
                    .onTapGesture {
                        selected = .home
                    }
                
                Spacer()
                
                MyFeedTabBar(isSelected: selected == .myFeed)
                    .onTapGesture {
                        selected = .myFeed
                    }
                
                Spacer()
                    .frame(width: 60)
            }
            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 72)
            .background(Color(PIMOAsset.Assets.gray.color))
            .cornerRadius(20, corners: [.topLeft, .topRight])
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct HomeTabBar: View {
    var isSelected: Bool = false
    
    var body: some View {
        if isSelected {
            Image(uiImage: PIMOAsset.Assets.homeFill.image)
                .frame(width: 28, height: 28)
        } else {
            Image(uiImage: PIMOAsset.Assets.home.image)
                .frame(width: 28, height: 28)
        }
    }
}

struct MyFeedTabBar: View {
    var isSelected: Bool = false
    
    var body: some View {
        if isSelected {
                Image(uiImage: PIMOAsset.Assets.example.image)
                    .frame(width: 28, height: 28)
                    .cornerRadius(14)
                    .overlay(Circle().stroke(Color.black, lineWidth: 1.5).frame(width: 32, height: 32))
        } else {
            Image(uiImage: PIMOAsset.Assets.example.image)
                .frame(width: 28, height: 28)
                .cornerRadius(14)
        }
    }
}
