//
//  MyFeedView.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/13.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct MyFeedView: View {
    let store: StoreOf<MyFeedStore>
    
    var body: some View {
        Text("MyFeed")
    }
}

struct MyFeedView_Previews: PreviewProvider {
    static var previews: some View {
        MyFeedView(
            store: Store(
                initialState: MyFeedStore.State(),
                reducer: MyFeedStore()))
    }
}
