//
//  TabBarView.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/13.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct TabBarView: View {
    let store: StoreOf<TabBarStore>
    
    var tabBarItems = TabBarItem.allCases
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                TabView(selection: viewStore.binding(\.$tabBarItem)) {
                    HomeView(
                        store: store.scope(
                            state: \.homeState,
                            action: TabBarStore.Action.home
                        )
                    )
                    .tag(tabBarItems[0])
                    
                    ArchiveView(
                        store: store.scope(
                            state: \.myFeedState,
                            action: TabBarStore.Action.myFeed
                        )
                    )
                    .tag(tabBarItems[1])
                }
                .onAppear {
                    viewStore.send(.fetchProfile)
                    UITabBar.appearance().isHidden = true
                }
                
                TabBar(selected: viewStore.binding(\.$tabBarItem),
                       profileImage: viewStore.state.myProfile?.profileImgUrl)
                
                uploadButton(viewStore: viewStore)
            }
            .ignoresSafeArea(.all)
            .toast(isShowing: viewStore.binding(\.$isShowToast), title: viewStore.toastMessage.title)
        }
    }
    
    func uploadButton(viewStore: ViewStore<TabBarStore.State, TabBarStore.Action>) -> some View {
        ZStack {
            Circle()
                .frame(width: 72, height: 72)
            
            Image(uiImage: PIMOAsset.Assets.plus.image)
                .frame(width: 24, height: 24)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .offset(x: 0, y: -36)
        .onTapGesture {
            viewStore.send(TabBarStore.Action.setSheetState)
        }
        .fullScreenCover(isPresented: viewStore.binding(\.$isSheetPresented)) {
            UploadView(
                store: store.scope(
                    state: \.uploadState,
                    action: TabBarStore.Action.upload
                )
            )
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(
            store: Store(
                initialState: TabBarStore.State(),
                reducer: TabBarStore()))
    }
}
