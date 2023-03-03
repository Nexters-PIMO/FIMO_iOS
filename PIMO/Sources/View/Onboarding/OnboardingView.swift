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
    let store: StoreOf<OnboardingStore>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack(alignment: .top) {
                if viewStore.pageType == OnboardingPageType.allCases.first {
                    viewStore.pageType.backgroundImage
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                } else {
                    viewStore.pageType.backgroundImage
                        .padding(.top, 40)
                }

                TabView(selection: viewStore.binding(\.$pageType)) {
                    ForEach(OnboardingPageType.allCases, id: \.self) {
                        OnboardingDescriptionView(type: $0)
                            .tag($0)
                    }
                }
                .ignoresSafeArea()
                .tabViewStyle(.page(indexDisplayMode: .never))

                ZStack {
                    if viewStore.pageType != OnboardingPageType.allCases.last {
                        skipButton(viewStore: viewStore)

                        indexDisplay(viewStore: viewStore)
                    } else {
                        startButton(viewStore: viewStore)
                    }
                }
                .transition(.opacity)
                .animation(.easeInOut, value: viewStore.pageType)
            }
        }
    }

    func startButton(viewStore: ViewStore<OnboardingStore.State, OnboardingStore.Action>) -> some View {
        VStack(alignment: .center) {
            Spacer()
            Button {
                viewStore.send(.startButtonTapped)
            } label: {
                HStack(spacing: 0) {
                    Image(uiImage: PIMOAsset.Assets.simpleLogo.image)
                        .resizable()
                        .frame(width: 30, height: 20)

                    Text("피모 시작하기")
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

    func skipButton(viewStore: ViewStore<OnboardingStore.State, OnboardingStore.Action>) -> some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    viewStore.send(.skipButtonTapped)
                } label: {
                    Text("SKIP")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(Color(PIMOAsset.Assets.red1.color))
                }
                .padding([.top, .trailing], 20)
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
                        .fill($0 == viewStore.pageType ? Color(PIMOAsset.Assets.red1.color) : Color(PIMOAsset.Assets.gray1.color))
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
