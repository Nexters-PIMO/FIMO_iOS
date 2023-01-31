//
//  ContentView.swift
//  PIMO
//
//  Created by 김영인 on 2023/01/20.
//  Copyright © 2023 PIMO. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct LoginView: View {
    let store: StoreOf<LoginStore>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
            }
            .padding()
            .onAppear {
                viewStore.send(.tappedAppleLoginButton)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            store: Store(
                initialState: LoginStore.State(),
                reducer: LoginStore()
            )
        )
    }
}
