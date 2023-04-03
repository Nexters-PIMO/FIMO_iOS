//
//  TabBar.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/13.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Kingfisher

enum TabBarItem: CaseIterable {
    case home
    case myFeed
}

extension TabBarView {
    struct TabBar: View {
        @Binding var selected: TabBarItem
        let profileImage: String?
        
        var body: some View {
            ZStack {
                HStack(alignment: .center) {
                    Spacer()
                    
                    HomeTabBar(isSelected: selected == .home)
                        .onTapGesture {
                            selected = .home
                        }
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    MyFeedTabBar(isSelected: selected == .myFeed,
                                 profileImage: profileImage)
                    .onTapGesture {
                        selected = .myFeed
                    }
                    
                    Spacer()
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
                Image(uiImage: PIMOAsset.Assets.homeSelected.image)
                    .frame(width: 28, height: 28)
            } else {
                Image(uiImage: PIMOAsset.Assets.home.image)
                    .frame(width: 28, height: 28)
            }
        }
    }
    
    struct MyFeedTabBar: View {
        var isSelected: Bool = false
        var profileImage: String?
        
        var body: some View {
            let url = URL(string: profileImage ?? "")
            
            if isSelected {
                KFImage(url)
                    .placeholder { Image(systemName: "person.fill") }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 28, height: 28)
                    .mask {
                        Circle()
                    }
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 1.5)
                            .frame(width: 32, height: 32)
                    )
            } else {
                KFImage(url)
                    .placeholder { Image(systemName: "person") }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 28, height: 28)
                    .mask {
                        Circle()
                    }
            }
        }
    }
}
