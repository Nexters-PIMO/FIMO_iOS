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
    
    let width = UIScreen.main.bounds.width - 5
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack(path: viewStore.binding(\.$path)) {
                VStack {
                    archiveTopBar
                        .frame(height: 64)
                    
                    if viewStore.isLoading {
                        LoadingView()
                    } else {
                        archiveFeedView(viewStore)
                            .refreshable {
                                viewStore.send(.refresh)
                            }
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .navigationDestination(for: ArchiveScene.self) { scene in
                    switch scene {
                    case .friends:
                        IfLetStore(
                            self.store.scope(state: \.friends, action: { .friends($0) })
                        ) {
                            FriendsListView(store: $0)
                        }
                    case .setting:
                        IfLetStore(
                            self.store.scope(state: \.setting, action: { .setting($0) })
                        ) {
                            SettingView(store: $0)
                        }

                    case .openSourceLicence:
                        AcknowView()
                    case .modifyProfile:
                        IfLetStore(
                            self.store.scope(state: \.profile, action: { .profile($0) })
                        ) {
                            ModifyProfileView(store: $0)
                        }
                    default:
                        EmptyView()
                    }
                }
                .toast(isShowing: viewStore.binding(\.$isShowToast),
                       title: viewStore.toastMessage.title,
                       message: viewStore.toastMessage.message)
                .sheet(isPresented: viewStore.binding(\.$isBottomSheetPresented)) {
                    IfLetStore(
                        self.store.scope(state: \.bottomSheet, action: { .bottomSheet($0) })
                    ) {
                        BottomSheetView(store: $0)
                            .presentationDragIndicator(.visible)
                            .presentationDetents([.height((viewStore.bottomSheet?.bottomSheetType == .me) ? 110 : 60)])
                    }
                }
            }
        }
    }
    
    func archiveFeedView(_ viewStore: ViewStore<ArchiveStore.State, ArchiveStore.Action>) -> some View {
        ScrollView {
            ZStack {
                profileView(viewStore)
            }
            
            IfLetStore(
                self.store.scope(state: \.post, action: { .postDetail($0) })
            ) {
                postDetail(viewStore, postStore: $0)
            } else: {
                if viewStore.feedsType == .basic {
                    basicFeedView(viewStore)
                        .padding(.bottom, 72)
                } else {
                    gridFeedView(viewStore)
                        .padding(.bottom, 72)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    // 피드 기본 모드로 보기
    func basicFeedView(_ viewStore: ViewStore<ArchiveStore.State, ArchiveStore.Action>) -> some View {
        LazyVStack(alignment: .center, pinnedViews: [.sectionHeaders]) {
            Section(header: postsHeader(viewStore)) {
                if viewStore.posts.isEmpty {
                    ArchiveEmptyView(archiveType: viewStore.archiveType)
                        .frame(height: UIScreen.screenHeight - 350)
                } else {
                    ForEachStore(
                        self.store.scope(
                            state: \.posts,
                            action: ArchiveStore.Action.post(id:action:)
                        )
                    ) {
                        PostView(store: $0)
                        
                        Spacer()
                            .frame(height: 12)
                        
                        Divider()
                            .background(Color(FIMOAsset.Assets.grayDivider.color))
                            .padding([.leading, .trailing], 20)
                    }
                }
            }
        }
    }
    
    // 피드 그리드 모드로 보기
    func gridFeedView(_ viewStore: ViewStore<ArchiveStore.State, ArchiveStore.Action>) -> some View {
        LazyVGrid(
            columns: viewStore.posts.isEmpty
            ? [GridItem(.flexible())] : columns,
            alignment: .center,
            spacing: 5,
            pinnedViews: [.sectionHeaders]
        ) {
            Section(header: postsHeader(viewStore)) {
                if viewStore.posts.isEmpty {
                    ArchiveEmptyView(archiveType: viewStore.archiveType)
                        .frame(height: UIScreen.screenHeight - 344)
                } else {
                    ForEach(viewStore.state.gridPosts, id: \.self) { post in
                        KFImage(URL(string: post.items[0].imageUrl))
                            .placeholder {
                                Rectangle()
                                    .foregroundColor(.gray)
                            }
                            .resizable()
                            .frame(height: width/2)
                            .onTapGesture {
                                viewStore.send(.postDidTap(post.id))
                            }
                    }
                }
            }
        }
    }
    
    // 글사진 상세
    func postDetail(_ viewStore: ViewStore<ArchiveStore.State, ArchiveStore.Action>, postStore: Store<PostStore.State, PostStore.Action>) -> some View {
        VStack {
            Rectangle()
                .fill(Color.white)
                .frame(height: 1)
                .shadow(color: Color(FIMOAsset.Assets.grayShadow.color).opacity(0.3), radius: 5, x: 0, y: 0)
                .mask(Rectangle().padding(.bottom, -12))
            
            Spacer()
                .frame(height: 20)
            
            ZStack {
                HStack {
                    Button {
                        viewStore.send(.feedsTypeButtonDidTap(.grid))
                    } label: {
                        Image(uiImage: FIMOAsset.Assets.back.image)
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                }
                
                HStack {
                    Text("글사진")
                        .font(Font(FIMOFontFamily.Pretendard.medium.font(size: 18)))
                }
                
                Spacer()
            }
            
            Divider()
                .background(Color(FIMOAsset.Assets.grayDivider.color))
                .padding([.leading, .trailing], 20)
            
            PostView(store: postStore)
            
            Spacer()
                .frame(height: 16)
            
            Divider()
                .background(Color(FIMOAsset.Assets.grayDivider.color))
                .padding([.leading, .trailing], 20)
        }
    }
    
    // 아카이브 상단 프로필 뷰
    func profileView(_ viewStore: ViewStore<ArchiveStore.State, ArchiveStore.Action>) -> some View {
        HStack {
            KFImage(URL(string: viewStore.archiveProfile.profileImageUrl))
                .placeholder { Image(systemName: "person") }
                .resizable()
                .frame(width: 52, height: 52)
                .mask {
                    Circle()
                }
            
            Spacer()
                .frame(width: 16)
            
            VStack(alignment: .leading) {
                Text(viewStore.archiveProfile.nickname)
                    .font(Font(FIMOFontFamily.Pretendard.medium.font(size: 16)))
                
                Text(FIMOStrings.archivingTextImage(viewStore.posts.count))
                    .font(Font(FIMOFontFamily.Pretendard.regular.font(size: 14)))
                    .foregroundColor(Color(FIMOAsset.Assets.grayText.color))
            }
            
            Spacer()
            
            ZStack {
                Rectangle()
                    .frame(width: 64, height: 40)
                    .foregroundColor(Color(FIMOAsset.Assets.grayButton.color))
                
                Image(uiImage: FIMOAsset.Assets.friendlist.image)
            }
            .onTapGesture {
                viewStore.send(.friendListButtonDidTap)
            }
        }
        .frame(height: 52)
        .padding([.leading, .trailing], 20)
    }
    
    // 아카이브 상단 글 사진 뷰
    func postsHeader(_ viewStore: ViewStore<ArchiveStore.State, ArchiveStore.Action>) -> some View {
        HStack {
            Image(uiImage: FIMOAsset.Assets.archiveLogo.image)
            
            Text(FIMOStrings.textImageTitle(viewStore.posts.count))
                .font(Font(FIMOFontFamily.Pretendard.medium.font(size: 16)))
                .foregroundColor(.black)
            
            Spacer()
                .frame(width: 8)
            
            Spacer()
            
            Image(uiImage: viewStore.feedsType == .basic ?
                  FIMOAsset.Assets.basicModeSelected.image : FIMOAsset.Assets.basicMode.image)
            .onTapGesture {
                viewStore.send(.feedsTypeButtonDidTap(.basic))
            }
            
            Spacer()
                .frame(width: 16)
            
            Image(uiImage: viewStore.feedsType == .grid ?
                  FIMOAsset.Assets.gridModeSelected.image : FIMOAsset.Assets.gridMode.image)
            .onTapGesture {
                viewStore.send(.feedsTypeButtonDidTap(.grid))
            }
        }
        .frame(height: 52)
        .padding([.leading, .trailing], 20)
        .foregroundColor(.black)
        .background(
            Color.white
                .shadow(color: Color(FIMOAsset.Assets.grayShadow.color).opacity(0.1),
                        radius: 5)
                .mask(Rectangle().padding(.bottom, -15))
        )
    }
    
    // 아카이브 상단 이름 옆 버튼
    func archiveTopBarButton(_ viewStore: ViewStore<ArchiveView.ArchiveViewState, ArchiveStore.Action>) -> some View {
        switch viewStore.archiveType {
        default:
            return Image(uiImage: FIMOAsset.Assets.share.image)
            #warning("서버 값 없음")
            //        case .otherArchive:
            //            switch viewStore.archiveInfo.friendType {
            //            case .both:
            //                return Image(uiImage: PIMOAsset.Assets.bothFriend.image)
            //            case .me:
            //                return Image(uiImage: PIMOAsset.Assets.meFriend.image)
            //            case .other:
            //                return Image(uiImage: PIMOAsset.Assets.otherFriend.image)
            //            case .neither:
            //                return Image(uiImage: PIMOAsset.Assets.neitherFriend.image)
            //            }
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
