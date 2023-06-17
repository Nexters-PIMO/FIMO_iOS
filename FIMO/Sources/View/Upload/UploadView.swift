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
                        color: Color(FIMOAsset.Assets.grayShadow.color).opacity(0.1),
                        radius: 3,
                        x: 0,
                        y: 3
                    )
                    .padding(.bottom, 20)
                
                photoUploader(viewStore: viewStore)
                    .frame(width: screenWidth - 40, height: 88)
                    .padding(.bottom, 38)
                
                mainImage(viewStore: viewStore)
                    .frame(width: 353, height: 353)
                    
                Spacer()
                
                publishButton(viewStore: viewStore)
                    .padding(.bottom, 60)
                    .frame(width: 353, height: 56)
            }
            .modifier(ClosePopupViewModifier(
                viewStore: viewStore,
                isShowing: viewStore.binding(\.$isClose)
            ))
            .toast(
                isShowing: viewStore.binding(\.$isShowOCRErrorToast),
                title: viewStore.state.toastMessage?.title ?? "",
                message: viewStore.state.toastMessage?.message ?? "",
                isTabBarVisible: false
            )
        }
    }
    
    private func topBar(
        viewStore: ViewStore<UploadStore.State, UploadStore.Action>,
        screenWidth: CGFloat
    ) -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
            HStack {
                Button {
                    if viewStore.state.uploadedImages.isEmpty {
                        viewStore.send(.didTapCloseButton)
                    } else {
                        viewStore.send(.didTapCloseButtonWithData)
                    }
                } label: {
                    Image(uiImage: FIMOAsset.Assets.closeBlack.image)
                }
                .frame(width: 24, height: 24)
                .padding(.leading, 20)
                
                Text("새 글사진")
                    .font(Font(FIMOFontFamily.Pretendard.medium.font(size: 18)))
                    .frame(width: 69, height: 18)
                    .padding(.leading, (screenWidth - 69) / 2 - 44)
                
                Spacer()
            }
        }
        .frame(width: screenWidth, height: 64)
    }
    
    private func photoUploader(viewStore: ViewStore<UploadStore.State, UploadStore.Action>) -> some View {
        HStack(spacing: 8) {
            uploadButton(viewStore: viewStore)
                .onTapGesture {
                    if viewStore.state.uploadedImages.count < 5 {
                        viewStore.send(.didTapUploadButton)
                    }
                }
                .frame(width: 76, height: 86)
                .padding(.bottom, 1)
            
            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    uploadedImage(viewStore: viewStore)
                        .frame(width: 76, height: 86)
                        .padding(.bottom, 1)
                }
            }
        }
        .sheet(isPresented: viewStore.binding(\.$isShowImagePicker)) {
            ImagePicker { uiImage in
                let uploadImage = UploadImage(
                    id: viewStore.uploadedImages.count,
                    image: uiImage
                )
                
                viewStore.send(.selectProfileImage(uploadImage))
            }
        }
    }
    
    private func uploadButton(viewStore: ViewStore<UploadStore.State, UploadStore.Action>) -> some View {
        ZStack {
            VStack {
                Spacer()
                
                Rectangle()
                    .foregroundColor(Color(uiColor: FIMOAsset.Assets.gray0.color))
                    .frame(width: 72, height: 72)
            }
            
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .foregroundColor(Color(FIMOAsset.Assets.gray1.color))
                        .frame(width: 20, height: 20)
                    
                    Image(uiImage: FIMOAsset.Assets.uploadButton.image)
                }
                .padding(.bottom, 4)

                Image(uiImage: FIMOAsset.Assets.imageBlack.image)
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .padding(.bottom, 8)
                
                HStack(spacing: 0) {
                    Text("\(viewStore.uploadedImages.count)")
                    Text("/5")
                        .foregroundColor(Color(FIMOAsset.Assets.gray3.color))
                }
                .font(Font(FIMOFontFamily.Pretendard.medium.font(size: 16)))
                .frame(width: 26, height: 18)
            }
        }
    }
    
    private func uploadedImage(viewStore: ViewStore<UploadStore.State, UploadStore.Action>) -> some View {
            ForEach(viewStore.uploadedImages) { uploadedImage in
                ZStack {
                    VStack {
                        Spacer(minLength: 14)
                        
                        Image(uiImage: uploadedImage.image)
                            .resizable()
                            .renderingMode(.original)
                            .scaledToFit()
                            .cornerRadius(2)
                            .frame(width: 72, height: 72)
                            .overlay {
                                if uploadedImage.id == .zero {
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(Color(FIMOAsset.Assets.red3.color), lineWidth: 2)
                                }
                            }
                    }
                    
                    VStack {
                        Image(uiImage: FIMOAsset.Assets.deleteButton.image)
                            .onTapGesture {
                                viewStore.send(.didTapDeleteButton(uploadedImage.id))
                            }
                            .frame(width: 20, height: 20)
                            .padding(.bottom, 58)
                    }
                    
                    if uploadedImage.id == .zero {
                        VStack {
                            Spacer(minLength: 63.5)
                            
                            ZStack {
                                Color.black.opacity(0.7)
                                Text("대표 글사진")
                                    .foregroundColor(.white)
                                    .font(Font(FIMOFontFamily.Pretendard.medium.font(size: 12)))
                            }
                            .frame(width: 70, height: 22.5)
                        }
                    }
                }
                .onTapGesture {
                    viewStore.send(.didTapUploadedImage(uploadedImage))
                }
            }
    }
    
    private func mainImage(viewStore: ViewStore<UploadStore.State, UploadStore.Action>) -> some View {
        ZStack {
            if viewStore.state.uploadedImages.isEmpty {
                RoundedRectangle(cornerRadius: 2)
                    .foregroundColor(Color(FIMOAsset.Assets.gray0.color))
                    .frame(width: 353, height: 353)
                
                VStack {
                    Image(uiImage: FIMOAsset.Assets.simpleLogo.image)
                        .renderingMode(.template)
                        .foregroundColor(Color(FIMOAsset.Assets.gray4.color))
                        .padding(.bottom, 15.2)
                    
                    Text("미리보기")
                        .font(Font(FIMOFontFamily.Pretendard.medium.font(size: 19)))
                        .foregroundColor(.black)
                        .padding(.bottom, 11)
                    
                    Text("미리보고 싶은 썸네일을 선택해주세요")
                        .font(Font(FIMOFontFamily.Pretendard.medium.font(size: 14)))
                        .foregroundColor(Color(FIMOAsset.Assets.gray3.color))
                }
            } else {
                Image(uiImage: viewStore.selectedImage?.image ?? UIImage())
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFit()
                    .cornerRadius(2)
                    .frame(width: 353, height: 353)
            }
        }
    }
    
    private func publishButton(viewStore: ViewStore<UploadStore.State, UploadStore.Action>) -> some View {
        Button {
            if !viewStore.state.uploadedImages.isEmpty {
                viewStore.send(.didTapPublishButton)
            }
        } label: {
            ZStack {
                let gray = Color(uiColor: FIMOAsset.Assets.gray4.color)
                let orange = Color(uiColor: FIMOAsset.Assets.red3.color)

                RoundedRectangle(cornerRadius: 2)
                    .fill(viewStore.state.uploadedImages.isEmpty ? gray : orange)
                    .frame(width: 353, height: 56)
                
                Text("게시하기")
                    .font(Font(FIMOFontFamily.Pretendard.medium.font(size: 16)))
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(.plain)
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
