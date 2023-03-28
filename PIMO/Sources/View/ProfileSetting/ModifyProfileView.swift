//
//  ModifyProfileView.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/28.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Kingfisher

struct ModifyProfileView: View {
    let store: StoreOf<ProfileSettingStore>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {

                    profileImageButton(viewStore)

                    Text("닉네임")
                        .font(.system(size: 16))
                        .padding(.top, 60)

                    nicknameSearchBar(viewStore)

                    Text(viewStore.nicknameValidationType.description)
                        .padding(.top, 10)
                        .font(.system(size: 12))
                        .foregroundColor(viewStore.nicknameValidationType.color)

                    Text("아카이브 이름")
                        .font(.system(size: 16))
                        .padding(.top, 46)

                    archiveNameSearchBar(viewStore)

                    Text(viewStore.archiveValidationType.description)
                        .padding(.top, 10)
                        .font(.system(size: 12))
                        .foregroundColor(viewStore.archiveValidationType.color)

                    Spacer()

                    completeButton(viewStore)
                }
                .padding(.horizontal, 20)
            }
            .sheet(isPresented: viewStore.binding(\.$isShowImagePicker)) {
                ImagePicker { uiImage in
                    viewStore.send(.selectProfileImage(uiImage))
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }

    func profileImageButton(_ viewStore: ViewStore<ProfileSettingStore.State, ProfileSettingStore.Action>) -> some View {
        ZStack(alignment: .bottomTrailing) {
            KFImage(URL(string: viewStore.selectedImageURL ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120)
                .cornerRadius(4)
                .zIndex(0)

            ZStack {
                Rectangle()

                Circle()
                    .blendMode(.destinationOut)
            }
            .frame(width: 120, height: 120)
            .compositingGroup()
            .foregroundColor(.black)
            .opacity(0.6)
            .zIndex(1)

            Button {
                viewStore.send(.tappedImagePickerButton)
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(Color(PIMOAsset.Assets.orange.color))
                        .frame(width: 32, height: 32)

                    Image("edit")
                }
            }
            .offset(.init(width: 7, height: 12))
            .zIndex(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 55)
    }

    func completeButton(_ viewStore: ViewStore<ProfileSettingStore.State, ProfileSettingStore.Action>) -> some View {
        Button {
            viewStore.send(.tappedCompleteModifyButton)
        } label: {
            Text("저장하기")
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 56)
                .background(
                    viewStore.isChangedInfo
                    ? Color(PIMOAsset.Assets.red2.color)
                    : Color(PIMOAsset.Assets.gray1.color)
                    )
                .cornerRadius(2)
        }
        .disabled(!viewStore.isChangedInfo)
        .padding(.top, 34)
        .padding(.bottom, 60)
    }

    func nicknameSearchBar(_ viewStore: ViewStore<ProfileSettingStore.State, ProfileSettingStore.Action>) -> some View {
        ZStack(alignment: .centerLastTextBaseline) {
            TextField("텍스트를 입력해주세요.", text: viewStore.binding(\.$nickname))
                .padding()
                .foregroundColor(
                    fieldColor(isBlack: viewStore.isBlackNicknameField)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .strokeBorder(Color(PIMOAsset.Assets.gray1.color))
                        .frame(height: 56)
                )
                .padding(.top, 13)

            HStack {
                Spacer()

                Button {
                    viewStore.send(.checkDuplicateOnNickName)
                } label: {
                    VStack(spacing: 3) {
                        Text("중복확인")
                            .font(.system(size: 16))
                            .foregroundColor(
                                fieldColor(isBlack: viewStore.isBlackNicknameField)
                            )

                        Divider()
                            .frame(width: 60)
                            .background(
                                fieldColor(isBlack: viewStore.isBlackNicknameField)
                            )
                    }

                }
                .disabled(viewStore.isBlackNicknameField)
                .padding(.trailing, 21)
                .padding(.top, 13)
            }
        }
    }

    func archiveNameSearchBar(_ viewStore: ViewStore<ProfileSettingStore.State, ProfileSettingStore.Action>) -> some View {
        ZStack(alignment: .centerLastTextBaseline) {
            TextField("텍스트를 입력해주세요.", text: viewStore.binding(\.$archiveName))
                .padding()
                .foregroundColor(
                    fieldColor(isBlack: viewStore.isBlackArchiveField)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .strokeBorder(Color(PIMOAsset.Assets.gray1.color))
                        .frame(height: 56)
                )
                .padding(.top, 13)

            HStack {
                Spacer()

                Button {
                    viewStore.send(.checkDuplicateOnArchive)
                } label: {
                    VStack(spacing: 3) {
                        Text("중복확인")
                            .font(.system(size: 16))
                            .foregroundColor(
                                fieldColor(isBlack: viewStore.isBlackArchiveField)
                            )

                        Divider()
                            .frame(width: 60)
                            .background(
                                fieldColor(isBlack: viewStore.isBlackArchiveField)
                            )
                    }

                }
                .disabled(viewStore.isBlackArchiveField)
                .padding(.trailing, 21)
                .padding(.top, 13)
            }
        }
    }

    func fieldColor(isBlack: Bool) -> Color {
        return isBlack ? Color(PIMOAsset.Assets.gray1.color) : Color.black
    }
}

struct ModifyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyProfileView(
            store: Store(
                initialState: ProfileSettingStore.State(),
                reducer: ProfileSettingStore()
            )
        )
    }
}
