//
//  ArchiveView.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/13.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Kingfisher

struct ArchiveView: View {
    let store: StoreOf<ArchiveStore>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                archiveTopBar
                    .frame(height: 64)
                
                archiveFeedView(viewStore)
            }
            .onAppear {
                viewStore.send(.fetchArchive)
            }
        }
    }
    
    func archiveFeedView(_ viewStore: ViewStore<ArchiveStore.State, ArchiveStore.Action>) -> some View {
        ScrollView {
            ZStack {
                profileView(viewStore)
            }
            LazyVStack(alignment: .center, pinnedViews: [.sectionHeaders]) {
                Section(header: feedsHeader(viewStore)) {
                    if viewStore.feeds.isEmpty {
                        Spacer()
                            .frame(height: 180)
                        ArchiveEmptyView(archiveType: viewStore.archiveType)
                    } else {
                        LazyVStack {
                            ForEachStore(
                                self.store.scope(
                                    state: \.feeds,
                                    action: ArchiveStore.Action.feed(id:action:)
                                )
                            ) {
                                FeedView(store: $0)
                                
                                Spacer()
                                    .frame(height: 12)
                                
                                Divider()
                                    .background(Color(PIMOAsset.Assets.grayDivider.color))
                                    .padding([.leading, .trailing], 20)
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 72)
        }
        
        .scrollIndicators(.hidden)
    }
    
    func profileView(_ viewStore: ViewStore<ArchiveStore.State, ArchiveStore.Action>) -> some View {
        HStack {
            KFImage(URL(string: viewStore.archiveInfo.profile.imageURL))
                .placeholder { Image(systemName: "person") }
                .resizable()
                .frame(width: 52, height: 52)
                .mask {
                    Circle()
                }
            
            Spacer()
                .frame(width: 16)
            
            VStack(alignment: .leading) {
                Text(viewStore.archiveInfo.profile.nickName)
                    .font(Font(PIMOFontFamily.Pretendard.medium.font(size: 16)))
                
                Text(PIMOStrings.archivingTextImage(viewStore.archiveInfo.feedCount))
                    .font(Font(PIMOFontFamily.Pretendard.regular.font(size: 14)))
                    .foregroundColor(Color(PIMOAsset.Assets.grayText.color))
            }
            
            Spacer()
            
            ZStack {
                Rectangle()
                    .frame(width: 64, height: 40)
                    .foregroundColor(Color(PIMOAsset.Assets.grayButton.color))
                
                Image(uiImage: PIMOAsset.Assets.friendlist.image)
            }
            .onTapGesture {
                viewStore.send(.friendListButtonDidTap)
            }
        }
        .frame(height: 52)
        .padding([.leading, .trailing], 20)
    }
    
    func feedsHeader(_ viewStore: ViewStore<ArchiveStore.State, ArchiveStore.Action>) -> some View {
        HStack {
            Image(uiImage: PIMOAsset.Assets.archiveLogo.image)
            
            Text(PIMOStrings.textImageTitle(viewStore.archiveInfo.feedCount))
                .font(Font(PIMOFontFamily.Pretendard.medium.font(size: 16)))
                .foregroundColor(.black)
            
            Spacer()
                .frame(width: 8)
            
            Spacer()
            
            Image(uiImage: viewStore.feedsType == .basic ?
                  PIMOAsset.Assets.basicModeSelected.image : PIMOAsset.Assets.basicMode.image)
                .onTapGesture {
                    viewStore.send(.feedsTypeButtonDidTap(.basic))
                }
            
            Spacer()
                .frame(width: 16)
            
            Image(uiImage: viewStore.feedsType == .grid ?
                  PIMOAsset.Assets.gridModeSelected.image : PIMOAsset.Assets.gridMode.image)
                .onTapGesture {
                    viewStore.send(.feedsTypeButtonDidTap(.grid))
                }
        }
        .frame(height: 52)
        .padding([.leading, .trailing], 20)
        .background(
            Color.white
                .shadow(color: Color(PIMOAsset.Assets.grayShadow.color).opacity(0.1),
                        radius: 5)
                .mask(Rectangle().padding(.bottom, -15))
        )
    }
    
    func archiveTopBarButton(_ viewStore: ViewStore<ArchiveView.ArchiveViewState, ArchiveStore.Action>) -> some View {
        switch viewStore.archiveType {
        case .myArchive:
            return Image(uiImage: PIMOAsset.Assets.share.image)
        case .otherArchive:
            switch viewStore.archiveInfo.friendType {
            case .both:
                return Image(uiImage: PIMOAsset.Assets.bothFriend.image)
            case .me:
                return Image(uiImage: PIMOAsset.Assets.meFriend.image)
            case .other:
                return Image(uiImage: PIMOAsset.Assets.meFriend.image)
            case .neither:
                return Image(uiImage: PIMOAsset.Assets.neitherFriend.image)
            }
        }
    }
}

struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView(
            store: Store(
                initialState: ArchiveStore.State(),
                reducer: ArchiveStore()))
    }
}
