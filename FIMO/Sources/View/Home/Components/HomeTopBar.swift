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
            self.postCount = state.posts.count
        }
    }
    
    @ViewBuilder
    var homeTopBar: some View {
        WithViewStore(self.store, observe: HomeViewState.init) { viewState in
            VStack(spacing: 37) {
                HStack {
                    Image(uiImage: FIMOAsset.Assets.fimoLogo.image)
                    
                    Spacer()

                    Button {
                        viewState.send(.settingButtonDidTap)
                    } label: {
                        Image(uiImage: FIMOAsset.Assets.setting.image)
                    }
                }
                
                HStack {
                    Text(FIMOStrings.friendPosts)
                        .font(.system(size: 20, weight: .semibold))
                    
                    Spacer()
                    
                    Text(FIMOStrings.newPost(viewState.postCount))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(FIMOAsset.Assets.grayText.color))
                        .isHidden(viewState.postCount == 0)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding([.top, .leading, .trailing], 20)
            .background(
                Color.white
                    .shadow(color: Color(FIMOAsset.Assets.grayShadow.color).opacity(0.1),
                            radius: 5)
                    .mask(Rectangle().padding(.bottom, -15))
            )
        }
    }
}
