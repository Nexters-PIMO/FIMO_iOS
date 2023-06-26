//
//  SettingView.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/25.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Kingfisher

struct SettingView: View {
    let store: StoreOf<SettingStore>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading) {
                CustomNavigationBar(title: "설정")

                HStack(alignment: .center) {
                    KFImage(URL(string: viewStore.profile.profileImageUrl))
                        .retry(maxCount: 3, interval: .seconds(5))
                        .cacheOriginalImage()
                        .resizable()
                        .placeholder({
                            Image(systemName: "person.crop.circle")
                                .font(.system(size: 40))
                        })
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .mask {
                            Circle()
                        }

                    VStack(alignment: .leading, spacing: 7) {
                        Text(viewStore.profile.nickname)
                            .font(.system(size: 16, weight: .medium))

                        Text(viewStore.profile.archiveName)
                            .font(.system(size: 16))
                            .foregroundColor(Color(FIMOAsset.Assets.grayText.color))
                    }
                    .padding(.leading, 16)

                    Spacer()

                    Button {
                        viewStore.send(.tappedProfileManagementButton)
                    } label: {
                        Text("프로필 관리")
                            .foregroundColor(Color(FIMOAsset.Assets.grayText.color))
                            .font(.system(size: 14))
                            .padding(.vertical, 9)
                            .padding(.horizontal, 9)
                            .overlay(
                                Capsule()
                                    .stroke(lineWidth: 1)
                                    .foregroundColor(.gray)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                Divider()
                    .padding(.vertical, 24)
                    .padding(.horizontal, 20)

                VStack(alignment: .leading, spacing: 38) {
                    Button {
                        viewStore.send(.tappedGuideAgainButton)
                    } label: {
                        Text("가이드 다시보기")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                    }

                    Button {
                        viewStore.send(.tappedLicenceButton)
                    } label: {
                        Text("오픈소스 라이선스")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                    }

                    if let url = viewStore.termsOfUseURL {
                        Link("개인정보 처리 방침 / 이용약관", destination: url)
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20)

                Divider()
                    .padding(.vertical, 24)
                    .padding(.horizontal, 20)

                VStack(alignment: .leading, spacing: 38) {
                    Button {
                        viewStore.send(.tappedLogoutButton)
                    } label: {
                        Text("로그아웃")
                            .font(.system(size: 18))
                            .foregroundColor(.black)
                    }

                    HStack {
                        Text("버전 정보")
                            .font(.system(size: 18))
                        Spacer()
                        Text(viewStore.version)
                            .font(.system(size: 14))
                            .foregroundColor(Color(FIMOAsset.Assets.grayText.color))
                    }
                }
                .padding(.horizontal, 20)

                Spacer()

                Button {
                    viewStore.send(.tappedWithdrawalButton)
                } label: {
                    Text("회원탈퇴")
                        .foregroundColor(Color(FIMOAsset.Assets.grayText.color))
                        .font(.system(size: 14))
                        .padding(.bottom, 3)
                        .border(width: 1, edges: [.bottom], color: Color(FIMOAsset.Assets.grayText.color))
                        .padding(.bottom, 120)
                }
                .padding(.horizontal, 20)
            }
            .backPopup(isShowing: viewStore.binding(\.$isShowBackPopup), store: viewStore)
            .fullScreenCover(isPresented: viewStore.binding(\.$isSheetPresented)) {
                IfLetStore(
                    self.store.scope(state: \.onboarding, action: { .onboarding($0) })
                ) {
                    OnboardingView(store: $0)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(
            store: Store(
                initialState: SettingStore.State(),
                reducer: SettingStore()
            )
        )
    }
}
