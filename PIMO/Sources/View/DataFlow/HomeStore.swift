//
//  HomeStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/01/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import ComposableArchitecture

struct HomeState: Equatable { }

enum HomeAction: Equatable { }

struct HomeEnvironment {
    let homeService: HomeServiceInterface
}

let homeReducer = AnyReducer<HomeState, HomeAction, HomeEnvironment> { state, action, environment in
    return
}
