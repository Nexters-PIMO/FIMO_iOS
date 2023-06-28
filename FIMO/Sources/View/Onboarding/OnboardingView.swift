//
//  OnboardingView.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/14.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct OnboardingView: View {
    @EnvironmentObject var sceneDelegate: SceneDelegate
    let store: StoreOf<OnboardingStore>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Color.white
                    .ignoresSafeArea()

                OnboardingCollectionView(viewStore: viewStore)
                    .ignoresSafeArea()
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.easeInOut, value: viewStore.pageType)
                    .transition(.opacity)
                    .zIndex(1)

                ZStack {
                    if viewStore.pageType != .four {
                        skipButton(viewStore: viewStore)
                        indexDisplay(viewStore: viewStore)
                    }
                }
                .transition(.opacity)
                .animation(.easeInOut, value: viewStore.pageType)
                .zIndex(2)
            }
            .ignoresSafeArea()
            .zIndex(0)
        }
    }

    func skipButton(viewStore: ViewStore<OnboardingStore.State, OnboardingStore.Action>) -> some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    viewStore.send(.skipButtonTapped)
                } label: {
                    Text("SKIP")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(Color(FIMOAsset.Assets.red1.color))
                }
                .padding(.top, 20 + (sceneDelegate.window?.safeAreaInsets.top ?? .zero))
                .padding(.trailing, 20 + (sceneDelegate.window?.safeAreaInsets.right ?? .zero))
            }
            Spacer()
        }
    }

    func indexDisplay(viewStore: ViewStore<OnboardingStore.State, OnboardingStore.Action>) -> some View {
        VStack {
            Spacer()
            HStack(spacing: 4) {
                ForEach(OnboardingPageType.allCases, id: \.self) {
                    Capsule()
                        .fill($0 == viewStore.pageType ? Color(FIMOAsset.Assets.red1.color) : Color(FIMOAsset.Assets.gray1.color))
                        .frame(width: $0 == viewStore.pageType ? 18 : 8, height: 6)
                        .animation(.easeInOut, value: viewStore.pageType)
                }
                Spacer()
            }
            .padding(.leading, 40)
            .padding(.bottom, 60)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(
            store: Store(
                initialState: OnboardingStore.State(),
                reducer: OnboardingStore()
            )
        )
    }
}
