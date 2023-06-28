//
//  OtherOnboardingView.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/28.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct OtherOnboardingView: View {
    @EnvironmentObject var sceneDelegate: SceneDelegate
    let viewStore: ViewStore<OnboardingStore.State, OnboardingStore.Action>
    let type: OnboardingPageType

    var isOverflowBottomText: Bool {
        sceneDelegate.window?.bounds.height ?? .zero * 0.35 < 281
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Spacer()
                type.backgroundImage
                    .resizable()
                    .frame(maxHeight: .infinity)
                    .padding(.top, 40)
                    .aspectRatio(contentMode: .fit)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(FIMOAsset.Assets.gray1.color))

            VStack(alignment: .leading, spacing: 0) {
                VStack(spacing: 0) {
                    OnboardingDescriptionView(type: type)

                    Spacer()

                    if type == .four {
                        startButton(viewStore: viewStore)
                    } else {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 313, height: 56)
                            .padding(.bottom, 60)
                    }
                }
                .if(isOverflowBottomText) { view in
                    view.frame(height: 281)
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }

    func startButton(viewStore: ViewStore<OnboardingStore.State, OnboardingStore.Action>) -> some View {
        VStack(alignment: .center) {
            Button {
                viewStore.send(.startButtonTapped)
            } label: {
                HStack(spacing: 0) {
                    Image(uiImage: FIMOAsset.Assets.simpleLogo.image)
                        .resizable()
                        .frame(width: 30, height: 20)

                    Text(viewStore.isAgainGuideReview ? "돌아가기" : "피모 시작하기")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(14)

                }
                .frame(width: 313, height: 56)
                .background(Color.black)
                .cornerRadius(4)
            }
            .padding(.bottom, 60)
        }
    }
}
