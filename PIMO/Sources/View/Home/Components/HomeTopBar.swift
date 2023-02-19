//
//  HomeTopBar.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/18.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

extension HomeView {
    struct HomeViewState: Equatable {
        let postCount: Int
        
        init(_ state: HomeStore.State) {
            self.postCount = state.feeds.count
        }
    }
    
    @ViewBuilder
    var homeTopBar: some View {
        WithViewStore(self.store, observe: HomeViewState.init) { viewState in
            VStack(spacing: 37) {
                HStack {
                    Image(uiImage: PIMOAsset.Assets.fimoLogo.image)
                    
                    Spacer()
                    
                    Image(uiImage: PIMOAsset.Assets.setting.image)
                }
                
                HStack {
                    Text(PIMOStrings.friendPosts)
                        .font(.system(size: 20, weight: .semibold))
                    
                    Spacer()
                    
                    Text(PIMOStrings.newPost(viewState.postCount))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(PIMOAsset.Assets.grayText.color))
                        .isHidden(viewState.postCount == 0)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
            .background(
                Color.white
                    .shadow(color: Color(PIMOAsset.Assets.grayShadow.color).opacity(0.1),
                            radius: 5)
                    .mask(Rectangle().padding(.bottom, -15))
            )
        }
    }
}
