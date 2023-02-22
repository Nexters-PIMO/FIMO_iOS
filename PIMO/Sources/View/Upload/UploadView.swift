//
//  UploadView.swift
//  PIMOTests
//
//  Created by 김영인 on 2023/02/14.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct UploadView: View {
    @EnvironmentObject var sceneDelegate: SceneDelegate
    let store: StoreOf<UploadStore>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            let screenWidth = sceneDelegate.window?.bounds.width ?? 0
            
            VStack {
                topBar(viewStore: viewStore, screenWidth: screenWidth)
                    .shadow(
                        color: Color(PIMOAsset.Assets.grayShadow.color).opacity(0.1),
                        radius: 3,
                        x: 0,
                        y: 3
                    )
                    
                Spacer()
            }
        }
    }
    
    func topBar(
        viewStore: ViewStore<UploadStore.State, UploadStore.Action>,
        screenWidth: CGFloat
    ) -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
            HStack {
                Button {
                    viewStore.send(.didTapCloseButton)
                } label: {
                    Image(uiImage: PIMOAsset.Assets.closeBlack.image)
                }
                .frame(width: 24, height: 24)
                .padding(.leading, 20)
                
                Text("새 글사진")
                    .font(Font(PIMOFontFamily.Pretendard.medium.font(size: 18)))
                    .frame(width: 69, height: 18)
                    .padding(.leading, (screenWidth - 69) / 2 - 44)
                
                Spacer()
            }
        }
        .frame(width: screenWidth, height: 64)
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView(
            store: Store(
                initialState: UploadStore.State(),
                reducer: UploadStore()))
    }
}
