//
//  GoogleAnalytics.swift
//  FIMO
//
//  Created by Ok Hyeon Kim on 2023/06/28.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

import FirebaseAnalytics

// MARK: 이벤트에 맞춰 추가 예정
enum AnalyticsEventType: String {
    case analyticsEventSelectItem
    case didTapButton
    case signUp
    case test
}

extension AnalyticsEventType {
    var value: String {
        switch self {
        case .analyticsEventSelectItem:
            return AnalyticsEventSelectItem
        default:
            return self.rawValue
        }
    }
}

class GoogleAnalytics {
    static let shared: GoogleAnalytics = GoogleAnalytics()

    func setUserId(_ id: String) {
        Analytics.setUserID(id)
    }

    func logEvent(_ event: AnalyticsEventType) {
        let parameters = [
          "file": #file,
          "function": #function
        ]

        Analytics.logEvent(event.value, parameters: parameters)
        Log.info("Send LogEvent: \(event.value), parameters: \(parameters)")
    }
}
