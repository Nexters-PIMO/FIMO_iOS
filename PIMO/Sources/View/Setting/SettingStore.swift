//
//  SettingStore.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/25.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct SettingStore: ReducerProtocol {
    struct State: Equatable {
        @BindingState var isShowLogoutPopup: Bool = false
        @BindingState var isShowWithdrawalPopup: Bool = false
        @BindingState var isShowBackPopup: Bool = false
        var nickname: String = "닉네임"
        var archiveName: String = "아카이브 이름"
        var imageURLString: String = ""
        var termsOfUseURL: URL? = URL(string: PIMOStrings.termsOfUseURL)

        var version: String {
            guard let dictionary = Bundle.main.infoDictionary,
                  let version = dictionary["CFBundleShortVersionString"] as? String else {
                return ""
            }

            return version
        }
    }

    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case tappedProfileManagementButton
        case tappedGuideAgainButton
        case tappedLicenceButton
        case tappedTermsOfUseButton
        case tappedLogoutButton
        case tappedWithdrawalButton
        case acceptLogout
        case acceptWithdrawal
        case acceptBack
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .tappedTermsOfUseButton:
                Link("Learn SwiftUI", destination: URL(string: "https://www.hackingwithswift.com/quick-start/swiftui")!)
                return .none
            default:
                return .none
            }
        }
    }
}
