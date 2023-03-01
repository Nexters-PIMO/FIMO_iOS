//
//  FeedView.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/18.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Kingfisher

struct FeedView: View {
    let store: StoreOf<FeedStore>
    
    let width = UIScreen.screenWidth - 40
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                // 피드 상단
                HStack {
                    KFImage(URL(string: viewStore.feed.profile.imageURL))
                        .placeholder { Image(systemName: "person") }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 28, height: 28)
                        .mask {
                            Circle()
                        }
                    
                    Spacer()
                        .frame(width: 12)
                    
                    Text(viewStore.feed.profile.nickName)
                        .font(.system(size: 14, weight: .medium))
                    
                    Spacer()
                    
                    Text(viewStore.feed.uploadTime)
                        .foregroundColor(Color(PIMOAsset.Assets.grayText.color))
                        .font(.system(size: 14))
                    
                    Spacer()
                        .frame(width: 18)
                    
                    Button {
                        viewStore.send(.moreButtonDidTap(viewStore.id))
                    } label: {
                        Image(uiImage: PIMOAsset.Assets.more.image)
                    }
                }
                
                Spacer()
                    .frame(height: 8)
                
                // 글사진
                ZStack {
                    TabView(selection: viewStore.binding(\.$textImage)) {
                        ForEach(viewStore.feed.textImages, id: \.self) {
                            FeedTextImageView(textImage: $0)
                                .tag($0)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: width)
                    .cornerRadius(4)
                }
                .overlay(textCopyButton(viewStore), alignment: .topLeading)
                .overlay(indexDisplay(viewStore), alignment: .bottom)
                
                Spacer()
                    .frame(height: 12)
                
                // 하단 버튼
                HStack {
                    clapButton(viewStore)
                    
                    Spacer()
                        .frame(width: 4)
                    
                    shareButton(viewStore)
                    
                    Spacer()
                    
                    audioButton(viewStore)
                }
            }
            .padding(EdgeInsets(top: 22, leading: 20, bottom: 0, trailing: 20))
            .onAppear {
                viewStore.send(.checkTextGuideClosed)
            }
        }
    }
    
    func textCopyButton(_ viewStore: ViewStore<FeedStore.State, FeedStore.Action>) -> some View {
        HStack(spacing: 4) {
            Button {
                viewStore.send(.copyButtonDidTap(viewStore.state.textImage.text))
            } label: {
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                    
                    Image(uiImage: PIMOAsset.Assets.copy.image)
                }
            }
            
            if !viewStore.state.closeButtonDidTap && viewStore.state.isFirstFeed {
                textGuideView(viewStore)
            }
        }
        .padding(.leading, 16)
        .padding(.top, 16)
    }
    
    func textGuideView(_ viewStore: ViewStore<FeedStore.State, FeedStore.Action>) -> some View {
        ZStack {
            Image(uiImage: PIMOAsset.Assets.textCopy.image)
            
            HStack {
                Spacer()
                    .frame(width: 12)
                
                Text(PIMOStrings.textCopy)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                    .frame(width: 3)
                
                Button {
                    viewStore.send(.closeButtonDidTap)
                } label: {
                    Image(uiImage: PIMOAsset.Assets.close.image)
                }
            }
        }
    }
    
    @ViewBuilder
    func indexDisplay(_ viewStore: ViewStore<FeedStore.State, FeedStore.Action>) -> some View {
        if viewStore.feed.textImages.count > 1 {
            HStack(spacing: 4) {
                ForEach(viewStore.feed.textImages, id: \.self) {
                    Circle()
                        .frame(width: 4, height: 4)
                        .foregroundColor(
                            ($0 == viewStore.textImage) ? Color(PIMOAsset.Assets.orange.color) : Color(PIMOAsset.Assets.grayUnactive.color))
                }
            }
            .padding(.bottom, 12)
        } else {
            EmptyView()
        }
    }
    
    func clapButton(_ viewStore: ViewStore<FeedStore.State, FeedStore.Action>) -> some View {
        Button {
            viewStore.send(.clapButtonDidTap)
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: 86, height: 38)
                    .foregroundColor(Color(PIMOAsset.Assets.grayButton.color))
                    .cornerRadius(20)
                
                HStack {
                    let clapButtonImage = viewStore.feed.isClapped ?
                    PIMOAsset.Assets.clapSelected.image : PIMOAsset.Assets.clap.image
                    
                    Image(uiImage: clapButtonImage)
                    
                    Text("\(viewStore.feed.clapCount)")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    func shareButton(_ viewStore: ViewStore<FeedStore.State, FeedStore.Action>) -> some View {
        Button {
            viewStore.send(.shareButtonDidTap)
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: 44, height: 38)
                    .foregroundColor(Color(PIMOAsset.Assets.grayButton.color))
                    .cornerRadius(20)
                
                Image(uiImage: PIMOAsset.Assets.share.image)
            }
        }
    }
    
    func audioButton(_ viewStore: ViewStore<FeedStore.State, FeedStore.Action>) -> some View {
        Button {
            viewStore.send(.audioButtonDidTap(viewStore.state.textImage.text))
        } label: {
            let audioButtonImage = viewStore.audioButtonDidTap ?
            PIMOAsset.Assets.audioSelected.image : PIMOAsset.Assets.audio.image
            
            Image(uiImage: audioButtonImage)
                .frame(width: 80, height: 20)
        }
    }
}
