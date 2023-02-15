//
//  MyFeedStore.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/13.
//  Copyright © 2023 pimo. All rights reserved.
//

import ComposableArchitecture

struct MyFeedStore: ReducerProtocol {
    struct State: Equatable { }
    
    enum Action: Equatable { }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}
