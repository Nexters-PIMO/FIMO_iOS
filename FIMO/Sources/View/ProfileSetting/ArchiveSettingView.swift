//
//  ArchiveSettingView.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/17.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct ArchiveSettingView: View {
    let store: StoreOf<ProfileSettingStore>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 0) {
                CustomNavigationBar(
                    title: "프로필 생성",
                    trailingItemType: .page(2, 3),
                    isShadowed: false
                )

                ProgressView(value: 66, total: 100)
                    .tint(Color(FIMOAsset.Assets.red1.color))

                VStack(alignment: .leading, spacing: 0) {
                    Text("나의 아카이브 이름을 입력해주세요")
                        .padding(.top, 42)
                        .font(.system(size: 20, weight: .semibold))

                    Text("공백 포함 한글 8자 영어 16자 이하로 정해주세요")
                        .padding(.top, 14)
                        .font(.system(size: 14))
                        .foregroundColor(Color(FIMOAsset.Assets.gray3.color))

                    searchBar(viewStore)

                    Text(viewStore.archiveValidationType.description)
                        .padding(.top, 10)
                        .font(.system(size: 12))
                        .foregroundColor(viewStore.archiveValidationType.color)

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
            viewStore.send(.tappedNextButtonOnArchive)
        } label: {
            Text("다음")
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 56)
                .background(
                    viewStore.isActiveButtonOnArchive
                    ? Color(FIMOAsset.Assets.red2.color)
                    : Color(FIMOAsset.Assets.gray1.color)
                    )
                .cornerRadius(2)
        }
        .disabled(!viewStore.isActiveButtonOnArchive)
        .padding(.top, 34)
    }

    func searchBar(_ viewStore: ViewStore<ProfileSettingStore.State, ProfileSettingStore.Action>) -> some View {
        ZStack(alignment: .centerLastTextBaseline) {
            TextField("텍스트를 입력해주세요.", text: viewStore.binding(\.$archiveName))
                .padding()
                .foregroundColor(
                    fieldColor(isBlackArchiveField: viewStore.isBlackArchiveField)
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
                    viewStore.send(.checkDuplicateOnArchive)
                } label: {
                    VStack(spacing: 3) {
                        Text("중복확인")
                            .font(.system(size: 16))
                            .foregroundColor(
                                fieldColor(isBlackArchiveField: viewStore.isBlackArchiveField)
                            )

                        Divider()
                            .frame(width: 60)
                            .background(
                                fieldColor(isBlackArchiveField: viewStore.isBlackArchiveField)
                            )
                    }

                }
                .disabled(viewStore.isBlackArchiveField)
                .padding(.trailing, 21)
            }
        }
    }

    func fieldColor(isBlackArchiveField: Bool) -> Color {
        return isBlackArchiveField ? Color(FIMOAsset.Assets.gray1.color) : Color.black
    }
}

struct ArchiveSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveSettingView(
            store: Store(
                initialState: ProfileSettingStore.State(),
                reducer: ProfileSettingStore()
            )
        )
    }
}
