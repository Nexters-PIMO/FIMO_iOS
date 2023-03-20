//
//  ToastView.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/20.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

/**
  하단 토스트를 띄웁니다

  *Values*

  `title`: 볼드처리된 타이틀

  `message`: 하단 설명. 옵셔널로 message가 nil이면 타이틀만 중앙에 표시가 됩니다

  `isTabBarVisible`: 탭바 여부에 따라 토스트 높이가 달라집니다

**구현 부분**
 ```
// View - 해당 Scene에 적용

 .toast(isShowing: viewStore.binding(\.$isShowToast),
        title: viewStore.waitingMessage.title,
        message: viewStore.waitingMessage.message)

 // State
 struct State: Equatable {
     @BindingState var isShowToast: Bool = false
     var waitingMessage: ToastModel = ToastModel(title: "")

 //Action
 case sendToast(ToastModel)
 case sendToastDone

 // Reducer
 case .sendToast(let toastModel):
     if state.isShowToast {
         return EffectTask<Action>(value: .sendToast(toastModel))
             .delay(for: .milliseconds(1000), scheduler: DispatchQueue.main)
             .eraseToEffect()
     } else {
         state.isShowToast = true
         state.waitingMessage = toastModel
         return EffectTask<Action>(value: .sendToastDone)
             .delay(for: .milliseconds(2000), scheduler: DispatchQueue.main)
             .eraseToEffect()
     }
 case .sendToastDone:
     // onAppear의 불완전한 호출로 확실한 Toast Off
     state.isShowToast = false
     return .none
 ```
 */
struct ToastView: View {
    let title: String
    var message: String?
    let isTabBarVisible: Bool

    var body: some View {
        ZStack(alignment: .center) {
            Color.black
                .opacity(0.8)

            VStack(alignment: .leading, spacing: 9) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                if let message = message {
                    Text(message)
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .light))
                }
            }
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 20)
            .padding(.horizontal, 35)
        }
        .frame(height: 79)
        .cornerRadius(2)
        .padding(.horizontal, 16)
        .padding(.bottom, isTabBarVisible ? 108 : 24)
    }
}

struct ToastViewModifier: ViewModifier {
    @Binding var isShowing: Bool
    let title: String
    var message: String?
    var duration: CGFloat = 1.5
    var isTabBarVisible: Bool = true

    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                Spacer()
                if isShowing {
                    ToastView(
                        title: title,
                        message: message,
                        isTabBarVisible: isTabBarVisible
                    )
                    .onTapGesture {
                        isShowing = false
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            isShowing = false
                        }
                    }
                }
            }
            .animation(.easeInOut, value: isShowing)
            .ignoresSafeArea()
        }
    }
}

extension View {
    func toast(isShowing: Binding<Bool>,
               title: String,
               message: String? = nil,
               duration: CGFloat = 1.5,
               isTabBarVisible: Bool = true) -> some View {
        return self.modifier(
            ToastViewModifier(
                isShowing: isShowing,
                title: title,
                message: message,
                duration: duration,
                isTabBarVisible: isTabBarVisible
            )
        )
    }
}

struct ToastViewPreView: PreviewProvider {
    @State static var isShow = false

    static var previews: some View {
        ToastView(title: "글사진 텍스트 복사 완료!", message: nil, isTabBarVisible: true)
    }
}
