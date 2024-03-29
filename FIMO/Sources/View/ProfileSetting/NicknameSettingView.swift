//
//  NicnameSettingView.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/16.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct NicknameSettingView: View {
    let store: StoreOf<ProfileSettingStore>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 0) {
                CustomNavigationBar(
                    title: "프로필 생성",
                    trailingItemType: .page(1, 3),
                    isShadowed: false
                )

                ProgressView(value: 33, total: 100)
                    .tint(Color(FIMOAsset.Assets.red1.color))

                VStack(alignment: .leading, spacing: 0) {
                    Text("닉네임을 입력해주세요")
                        .padding(.top, 42)
                        .font(.system(size: 20, weight: .semibold))

                    Text("닉네임은 한글 8자 영어 16자 이하로 정해주세요")
                        .padding(.top, 14)
                        .font(.system(size: 14))
                        .foregroundColor(Color(FIMOAsset.Assets.gray3.color))

                    searchBar(viewStore)

                    Text(viewStore.nicknameValidationType.description)
                        .padding(.top, 10)
                        .font(.system(size: 12))
                        .foregroundColor(viewStore.nicknameValidationType.descriptionColor)

                    nextButton(viewStore)
                }
                .padding(.horizontal, 20)

                Spacer()
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    func nextButton(_ viewStore: ViewStore<ProfileSettingStore.State, ProfileSettingStore.Action>) -> some View {
        Button {
            viewStore.send(.tappedNextButtonOnNickname)
        } label: {
            Text("다음")
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 56)
                .background(
                    viewStore.nicknameValidationType.isOKButtonClickable
                    ? Color(FIMOAsset.Assets.red2.color)
                    : Color(FIMOAsset.Assets.gray1.color)
                    )
                .cornerRadius(2)
        }
        .disabled(!viewStore.nicknameValidationType.isOKButtonClickable)
        .padding(.top, 34)
    }

    func searchBar(_ viewStore: ViewStore<ProfileSettingStore.State, ProfileSettingStore.Action>) -> some View {
        ZStack(alignment: .centerLastTextBaseline) {
            TextField("텍스트를 입력해주세요.", text: viewStore.binding(\.$nickname))
                .padding()
                .foregroundColor(
                    viewStore.nicknameValidationType.fieldColor
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .strokeBorder(Color(FIMOAsset.Assets.gray1.color))
                        .frame(height: 56)
                )
                .padding(.top, 32)

            HStack {
                Spacer()

                Button {
                    viewStore.send(.checkDuplicateOnNickName)
                } label: {
                    VStack(spacing: 3) {
                        Text("중복확인")
                            .font(.system(size: 16))
                            .foregroundColor(
                                viewStore.nicknameValidationType.duplicatedButtonColor
                            )

                        Divider()
                            .frame(width: 60)
                            .background(
                                viewStore.nicknameValidationType.duplicatedButtonColor
                            )
                    }

                }
                .disabled(!viewStore.nicknameValidationType.isDuplicateButtonEnabled)
                .padding(.trailing, 21)
            }
        }
    }
}

struct NicnameSettingView_Previews: PreviewProvider {
    static var previews: some View {
        NicknameSettingView(
            store: Store(
                initialState: ProfileSettingStore.State(),
                reducer: ProfileSettingStore()
            )
        )
    }
}
