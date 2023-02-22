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
                
                Button {
                    moreAction?()
                } label: {
                    Image(uiImage: PIMOAsset.Assets.more.image)
                }
            }
            
            Spacer()
                .frame(height: 8)
            
            // 글사진
            ZStack(alignment: .top) {
                TabView {
                    ForEach(feed.textImages, id: \.id) {
                        FeedTextImageView(textImage: $0)
                            .tag($0)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: width)
                .cornerRadius(4)
                
                textCopyButton()
                
                indexDisplay()
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
    
    func textCopyButton() -> some View {
        HStack(spacing: 4) {
            Button {
                copyAction?()
            } label: {
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                    
                    Image(uiImage: PIMOAsset.Assets.copy.image)
                }
            }
            
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
                        closeAction?()
                    } label: {
                        Image(uiImage: PIMOAsset.Assets.close.image)
                    }
                }
            }
        }
        .padding(.leading, -(width)/2 + 36)
        .padding(.top, 16)
    }
    
    func indexDisplay() -> some View {
        HStack(spacing: 4) {
            ForEach(feed.textImages, id: \.self) {
                Circle()
                    .frame(width: 4, height: 4)
                    .foregroundColor(
                        ($0 == selectedTextImage) ? Color(PIMOAsset.Assets.orange.color) : Color(PIMOAsset.Assets.grayUnactive.color))
            }
        }
        .padding(.top, width - 12)
        .isHidden(feed.textImages.count == 1)
    }
    
    func clapButton() -> some View {
        Button {
            clapAction?()
            clapButtonDidTap.toggle()
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: 86, height: 38)
                    .foregroundColor(Color(PIMOAsset.Assets.grayButton.color))
                    .cornerRadius(20)
                
                HStack {
                    if feed.isClapped {
                        Image(uiImage: PIMOAsset.Assets.clapSelected.image)
                    } else {
                        Image(uiImage: PIMOAsset.Assets.clap.image)
                    }
                    
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
        Button(action: {
            audioAction?()
            audioButtonDidTap.toggle()
        }) {
            if audioButtonDidTap {
                Image(uiImage: PIMOAsset.Assets.audioSelected.image)
                    .frame(width: 80, height: 20)
            } else {
                Image(uiImage: PIMOAsset.Assets.audio.image)
                    .frame(width: 80, height: 20)
            }
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
