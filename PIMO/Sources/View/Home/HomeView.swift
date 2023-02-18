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
                    FeedView()
                        .frame(maxHeight: .infinity)
                }
            }
            .onAppear {
                viewStore.send(.fetchFeeds)
            }
        }
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
