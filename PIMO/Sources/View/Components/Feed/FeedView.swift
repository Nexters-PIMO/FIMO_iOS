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
    private let feed: Feed
    
    init(feed: Feed) {
        self.feed = feed
    }
    
    var body: some View {
        VStack {
            // 피드 상단
            HStack {
                KFImage(URL(string: feed.profile.imageURL))
                    .placeholder { Image(systemName: "person") }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 28, height: 28)
                    .mask {
                        Circle()
                    }
                
                Spacer()
                    .frame(width: 12)
                
                Text(feed.profile.nickName)
                    .font(.system(size: 14, weight: .medium))
                
                Spacer()
                
                Text(feed.uploadTime)
                    .foregroundColor(Color(PIMOAsset.Assets.grayText.color))
                    .font(.system(size: 14))
                
                Spacer()
                    .frame(width: 18)
                
                Image(uiImage: PIMOAsset.Assets.more.image)
                    .onTapGesture {
                        // TODO: 바텀 시트
                    }
            }
            
            Spacer()
                .frame(height: 8)
            
            // 글사진
            ZStack {
                TabView {
                    ForEach(feed.textImages, id: \.id) { textImage in
                        FeedTextImageView(textImage: textImage)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(width: 353, height: 353)
                .cornerRadius(4)
            }
            
            Spacer()
                .frame(height: 12)
            
            // 하단 버튼
            HStack {
                clapButton()
                
                Spacer()
                    .frame(width: 4)
                
                shareButton()
                
                Spacer()
                
                audioButton()
            }
        }
        .padding(EdgeInsets(top: 22, leading: 20, bottom: 0, trailing: 20))
    }
    
    func clapButton() -> some View {
        Button(action: { print("clap") }) {
            ZStack {
                Rectangle()
                    .frame(width: 86, height: 38)
                    .foregroundColor(Color(PIMOAsset.Assets.grayButton.color))
                    .cornerRadius(20)
                
                HStack {
                    Image(uiImage: PIMOAsset.Assets.clap.image)
                    
                    Text("\(feed.clapCount)")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    func shareButton() -> some View {
        Button(action: { print("share") }) {
            ZStack {
                Rectangle()
                    .frame(width: 44, height: 38)
                    .foregroundColor(Color(PIMOAsset.Assets.grayButton.color))
                    .cornerRadius(20)
                
                Image(uiImage: PIMOAsset.Assets.share.image)
            }
        }
    }
    
    func audioButton() -> some View {
        Button(action: { print("audio") }) {
            Image(uiImage: PIMOAsset.Assets.audio.image)
                .frame(width: 80, height: 20)
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(feed:
                    Feed(id: 1,
                         profile: Profile(imageURL: PIMOStrings.profileImage, nickName: "0inn1"),
                         uploadTime: "5분 전",
                         textImages: [TextImage(
                            id: 1,
                            imageURL: PIMOStrings.textImage, text: "안녕"),
                                      TextImage(
                                        id: 2,
                                        imageURL: PIMOStrings.textImage, text: "안녕")],
                         clapCount: 310,
                         isClapped: false)
        )
    }
}
