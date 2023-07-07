//
//  PostView.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/18.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Kingfisher

struct PostView: View {
    let store: StoreOf<PostStore>
    
    let width = UIScreen.screenWidth - 40
    
    @State var plusButtonTimer: DispatchWorkItem?
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                VStack {
                    // 피드 상단
                    HStack {
                        #warning("프로필 이미지 추가 필요")
                        KFImage(URL(string: viewStore.post.user.archiveName))
                            .placeholder { Image(systemName: "person") }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 28, height: 28)
                            .mask {
                                Circle()
                            }
                        
                        Spacer()
                            .frame(width: 12)
                        
                        Text(viewStore.post.user.nickname)
                            .font(.system(size: 14, weight: .medium))
                        
                        Spacer()
                        
                        Text(viewStore.post.createdAt)
                            .foregroundColor(Color(FIMOAsset.Assets.grayText.color))
                            .font(.system(size: 14))
                        
                        Spacer()
                            .frame(width: 18)
                        
                        Button {
                            viewStore.send(.moreButtonDidTap(viewStore.id))
                        } label: {
                            Image(uiImage: FIMOAsset.Assets.more.image)
                        }
                    }
                    
                    Spacer()
                        .frame(height: 8)
                    
                    // 글사진
                    ZStack {
                        TabView(selection: viewStore.binding(\.$textImage)) {
                            ForEach(viewStore.post.items, id: \.self) {
                                PostTextImageView(postItem: $0)
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
            }
            .padding(EdgeInsets(top: 22, leading: 20, bottom: 0, trailing: 20))
            .onAppear {
                viewStore.send(.checkTextGuideClosed)
            }
            .overlay(
                clapPlusView(viewStore)
                    .animation(.easeOut(duration: 0.3), value: viewStore.state.isClapPlusViewShowing),
                alignment: .bottomLeading
            )
        }
    }
    
    // 텍스트 복사 버튼
    func textCopyButton(_ viewStore: ViewStore<PostStore.State, PostStore.Action>) -> some View {
        HStack(spacing: 4) {
            Button {
                viewStore.send(.copyButtonDidTap(viewStore.state.textImage.content))
            } label: {
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                    
                    Image(uiImage: FIMOAsset.Assets.copy.image)
                }
            }
            
            if !viewStore.state.closeButtonDidTap && viewStore.state.isFirstPost {
                textGuideView(viewStore)
            }
        }
        .padding(.leading, 16)
        .padding(.top, 16)
    }
    
    // 텍스트 복사하기 가이드 뷰
    func textGuideView(_ viewStore: ViewStore<PostStore.State, PostStore.Action>) -> some View {
        ZStack {
            Image(uiImage: FIMOAsset.Assets.textCopy.image)
            
            HStack {
                Spacer()
                    .frame(width: 12)
                
                Text(FIMOStrings.textCopy)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                    .frame(width: 3)
                
                Button {
                    viewStore.send(.closeButtonDidTap)
                } label: {
                    Image(uiImage: FIMOAsset.Assets.close.image)
                }
            }
        }
    }
    
    // 글 사진 하단 인덱스 뷰
    @ViewBuilder
    func indexDisplay(_ viewStore: ViewStore<PostStore.State, PostStore.Action>) -> some View {
        if viewStore.post.items.count > 1 {
            HStack(spacing: 4) {
                ForEach(viewStore.post.items, id: \.self) {
                    Circle()
                        .frame(width: 4, height: 4)
                        .foregroundColor(
                            ($0 == viewStore.textImage) ? Color(FIMOAsset.Assets.orange.color) : Color(FIMOAsset.Assets.grayUnactive.color))
                }
            }
            .padding(.bottom, 12)
        } else {
            EmptyView()
        }
    }
    
    // 박수 버튼
    func clapButton(_ viewStore: ViewStore<PostStore.State, PostStore.Action>) -> some View {
        Button {
            plusButtonTimer?.cancel()
            viewStore.send(.clapButtonDidTap)
            
            plusButtonTimer = DispatchWorkItem {
                viewStore.send(.clapButtonIsDone)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: plusButtonTimer!)
        } label: {
            ZStack {
                Rectangle()
                    .foregroundColor(Color(FIMOAsset.Assets.grayButton.color))
                    .cornerRadius(20)
                
                HStack {
                    let clapButtonImage = (viewStore.state.isClapped || viewStore.state.clapButtonDidTap) ?
                    FIMOAsset.Assets.clapSelected.image : FIMOAsset.Assets.clap.image
                    
                    Image(uiImage: clapButtonImage)
                        .frame(width: 24, height: 26)
                    
                    HStack {
                        Spacer()
                        
                        Text("\(viewStore.state.clapCount)")
                            .font(Font(FIMOFontFamily.Pretendard.regular.font(size: 16)))
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                }
                .padding([.leading, .trailing], 8)
            }
            .frame(width: 86, height: 38)
        }
    }
    
    // 박수 +0 버튼
    func clapPlusView(_ viewStore: ViewStore<PostStore.State, PostStore.Action>) -> some View {
        ZStack {
            if viewStore.state.plusClapCount !=  0 {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                
                Text("+\(viewStore.state.plusClapCount)")
                    .font(Font(FIMOFontFamily.Pretendard.medium.font(size: 18)))
                    .foregroundColor(.black)
            }
        }
        .padding(.leading, 20)
        .padding(.bottom, 46)
        .shadow(color: Color(FIMOAsset.Assets.grayShadow.color).opacity(0.3), radius: 5, x: 4, y: 4)
        .opacity(viewStore.state.isClapPlusViewShowing ? 1 : 0)
    }
    
    // 공유하기 버튼
    func shareButton(_ viewStore: ViewStore<PostStore.State, PostStore.Action>) -> some View {
        Button {
            viewStore.send(.shareButtonDidTap)
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: 44, height: 38)
                    .foregroundColor(Color(FIMOAsset.Assets.grayButton.color))
                    .cornerRadius(20)
                
                Image(uiImage: FIMOAsset.Assets.share.image)
            }
        }
    }
    
    // 오디오 버튼
    func audioButton(_ viewStore: ViewStore<PostStore.State, PostStore.Action>) -> some View {
        Button {
            let text = viewStore.state.textImage.content
            viewStore.send(.audioButtonDidTap(text))
        } label: {
            if viewStore.audioButtonDidTap {
                GifImageView(fileName: "audio_selected")
                    .frame(width: 82, height: 23)
            } else {
                Image(uiImage: FIMOAsset.Assets.audio.image)
                    .frame(width: 82, height: 23)
            }
        }
    }
}
