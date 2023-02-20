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
            VStack {
                homeTopBar
                    .frame(height: 116)
                
                if viewStore.feeds.isEmpty {
                    homeWelcome
                } else {
                    homeFeedView(viewStore: viewStore)
                }
            }
            .onAppear {
                viewStore.send(.fetchFeeds)
            }
        }
    }
    
    func homeFeedView(viewStore: ViewStore<HomeStore.State, HomeStore.Action>) -> some View {
        ScrollView {
            LazyVStack(alignment: .center) {
                VStack {
                    ForEach(viewStore.feeds, id: \.id) { feed in
                        FeedView(feed: feed)
                        
                        Spacer()
                            .frame(height: 12)
                        
                        Divider()
                            .background(Color(PIMOAsset.Assets.grayDivider.color))
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    }
                }
            }
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
