//
//  ProfilePictureSettingView.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/17.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct ProfilePictureSettingView: View {
    let store: StoreOf<ProfileSettingStore>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 0) {
                ProgressView(value: 100, total: 100)
                    .tint(Color(PIMOAsset.Assets.red1.color))

                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("프로필 사진을 등록해주세요")
                            .padding(.top, 42)
                            .font(.system(size: 20, weight: .semibold))
                    }

                    profileImageButton(viewStore)

                    nextButton(viewStore)
                }
                .padding(.horizontal, 20)

                Spacer()
            }
            .sheet(isPresented: viewStore.binding(\.$isShowImagePicker)) {
                ImagePicker { uiImage in
                    let image = Image(uiImage: uiImage)
                    viewStore.send(.selectProfileImage(image))
                }
            }
        }
    }

    func profileImageButton(_ viewStore: ViewStore<ProfileSettingStore.State, ProfileSettingStore.Action>) -> some View {
        VStack {
            Button(action: {
                viewStore.send(.tappedImagePickerButton)
            }, label: {
                if viewStore.selectedProfileImage == nil {
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(PIMOAsset.Assets.gray1.color), style: StrokeStyle(lineWidth: 1))
                            .aspectRatio(1.0, contentMode: .fit)
                            .foregroundColor(.clear)

                        Image(uiImage: PIMOAsset.Assets.image.image)
                    }
                } else {
                    ZStack {
                        viewStore.selectedProfileImage?
                            .resizable()
                            .aspectRatio(1.0, contentMode: .fit)
                            .cornerRadius(4)

                        ZStack {
                            Rectangle()

                            Circle()
                                .blendMode(.destinationOut)
                        }
                        .aspectRatio(1.0, contentMode: .fit)
                        .compositingGroup()
                        .foregroundColor(.black)
                        .opacity(0.6)
                    }

                }
            })
            .frame(maxWidth: .infinity)
            .padding(.top, 44)
        }
    }

    func nextButton(_ viewStore: ViewStore<ProfileSettingStore.State, ProfileSettingStore.Action>) -> some View {
        Button {

        } label: {
            Text("완료")
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 56)
                .background(
                    viewStore.isActiveButtonOnImage
                    ? Color(PIMOAsset.Assets.red2.color)
                    : Color(PIMOAsset.Assets.gray1.color)
                    )
                .cornerRadius(2)
        }
        .disabled(!viewStore.isActiveButtonOnImage)
        .padding(.top, 34)
    }
}

struct ProfilePictureSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePictureSettingView(
            store: Store(
                initialState: ProfileSettingStore.State(),
                reducer: ProfileSettingStore()
            )
        )
    }
}
