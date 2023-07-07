//
//  HomeView.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct HomeView: View {
    let store: StoreOf<HomeStore>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack(path: viewStore.binding(\.$path)) {
                VStack {
                    homeTopBar
                        .frame(height: 116)
                    
                    if viewStore.isLoading {
                        LoadingView()
                    } else if viewStore.posts.isEmpty {
                        homeWelcome
                            .refreshable {
                                viewStore.send(.refresh)
                            }
                    } else {
                        homeFeedView(viewStore: viewStore)
                            .refreshable {
                                viewStore.send(.refresh)
                            }
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .navigationDestination(for: HomeScene.self) { scene in
                    switch scene {
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
    
    func homeFeedView(viewStore: ViewStore<HomeStore.State, HomeStore.Action>) -> some View {
        ScrollView {
            LazyVStack(alignment: .center) {
                LazyVStack {
                    ForEachStore(
                        self.store.scope(
                            state: \.posts,
                            action: HomeStore.Action.post(id:action:)
                        )
                    ) {
                        FeedView(store: $0)
                        
                        Spacer()
                            .frame(height: 12)
                        
                        Divider()
                            .background(Color(FIMOAsset.Assets.grayDivider.color))
                            .padding([.leading, .trailing], 20)
                    }
                }
            }
            .padding(.bottom, 72)
        }
        .scrollIndicators(.hidden)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            store: Store(
                initialState: HomeStore.State(),
                reducer: HomeStore()
            )
        )
    }
}
