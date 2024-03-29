//
//  BottomSheetStore.swift
//  PIMO
//
//  Created by 김영인 on 2023/03/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import ComposableArchitecture

struct BottomSheetStore: ReducerProtocol {
    struct State: Equatable {
        var postId: String = ""
        var post: FMPost = .EMPTY
        var bottomSheetType: BottomSheetType = .me
    }
    
    enum Action: Equatable {
        case editButtonDidTap(FMPost)
        case deleteButtonDidTap(String)
        case declationButtonDidTap(String)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { _, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
