//
//  ArchiveTopBar.swift
//  PIMOTests
//
//  Created by 김영인 on 2023/02/26.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

extension ArchiveView {
    struct ArchiveViewState: Equatable {
        let archiveProfile: FMProfile
        let archiveType: ArchiveType
        
        init(_ state: ArchiveStore.State) {
            self.archiveProfile = state.archiveProfile
            self.archiveType = state.archiveType
        }
    }
    
    @ViewBuilder
    var archiveTopBar: some View {
        WithViewStore(self.store, observe: ArchiveViewState.init) { viewStore in
            HStack {
                Text(viewStore.archiveProfile.archiveName)
                    .font(Font(FIMOFontFamily.Pretendard.semiBold.font(size: 24)))
                    .foregroundColor(.black)
                
                Spacer()
                    .frame(width: 12)
                
                archiveTopBarButton(viewStore)
                    .onTapGesture {
                        viewStore.send(.topBarButtonDidTap)
                    }
                
                Spacer()
                
                Image(uiImage: FIMOAsset.Assets.setting.image)
                    .onTapGesture {
                        viewStore.send(.settingButtonDidTap)
                    }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding([.top, .leading, .trailing], 20)
        }
    }
}
