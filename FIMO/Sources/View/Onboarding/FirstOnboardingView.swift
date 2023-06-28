//
//  FirstOnboardingView.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/28.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct FirstOnboardingView: View {
    @EnvironmentObject var sceneDelegate: SceneDelegate
    let viewStore: ViewStore<OnboardingStore.State, OnboardingStore.Action>
    let type: OnboardingPageType

    var isOverflowBottomText: Bool {
        sceneDelegate.window?.bounds.height ?? .zero * 0.35 < 281
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Text("")
                Spacer()
            }
            VStack(alignment: .leading, spacing: 0) {
                Image(uiImage: FIMOAsset.Assets.logo.image)
                    .padding(.leading, 40)
                    .padding(.bottom, -20)

                VStack(spacing: 0) {
                    OnboardingDescriptionView(type: type)

                    Spacer()

                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 313, height: 56)
                        .padding(.bottom, 60)
                }
                .if(isOverflowBottomText) { view in
                    view.frame(height: 281)
                }

                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            OnboardingPageType.one.backgroundImage
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
        )
        .ignoresSafeArea()
    }
}
