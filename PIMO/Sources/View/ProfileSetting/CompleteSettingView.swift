//
//  CompleteSettingView.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/22.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct CompleteSettingView: View {
    let store: StoreOf<ProfileSettingStore>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading) {
                Image(uiImage: PIMOAsset.Assets.logo.image)
                    .resizable()
                    .frame(width: 44, height: 44)
                    .padding(.top, 56)

                Text("아카이브 생성 완료!")
                    .padding(.top, 24)
                    .font(.system(size: 28, weight: .bold))

                Spacer()

                Group {
                    paragraph(
                        image: Image(uiImage: PIMOAsset.Assets.completeLock.image),
                        title: "프라이빗 아카이브 기능",
                        body: "링크 없이 접근 불가\n개인별 아카이빙 유형 선택"
                    )

                    CustomDivider()
                        .padding(.vertical, 25)

                    paragraph(
                        image: Image(uiImage: PIMOAsset.Assets.completeOCR.image),
                        title: "텍스트 자동인식 및 추출 기능",
                        body: "사진 속 텍스트 자동인식 및 업로드 여부 판정\n사진 속 텍스트를 추출 및 클립보드에 복사"
                    )

                    CustomDivider()
                        .padding(.vertical, 25)

                    paragraph(
                        image: Image(uiImage: PIMOAsset.Assets.completeSTT.image),
                        title: "텍스트 오디오 재생 기능",
                        body: "사진 속 텍스트 보이스 리딩"
                    )
                }

                Spacer()
                Spacer()

                Button {
                    viewStore.send(.tappedCompleteButton)
                } label: {
                    Text("시작하기")
                        .font(.system(size: 16, weight: .medium))

                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 56)
                .background(Color(PIMOAsset.Assets.red1.color))
                .cornerRadius(2)
                .padding(.bottom, 60)

            }
            .padding(.horizontal, 19)
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    func paragraph(image: Image, title: String, body: String) -> some View {
        VStack(alignment: .leading) {
            HStack(spacing: 6) {
                image
                    .resizable()
                    .frame(width: 20, height: 20)

                Text(title)
                    .font(.system(size: 18, weight: .semibold))
            }

            Text(body)
                .font(.system(size: 14, weight: .light))
                .lineSpacing(4)
                .padding(.top, 6)
        }
    }
}

struct CompleteSettingView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteSettingView(store: Store(initialState: ProfileSettingStore.State(), reducer: ProfileSettingStore()))
    }
}
