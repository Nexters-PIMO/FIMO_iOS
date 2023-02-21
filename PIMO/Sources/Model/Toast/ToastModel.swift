//
//  ToastModel.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import Foundation

struct ToastModel: Equatable {
    let title: String
    let message: String?

    init(title: String, message: String? = nil) {
        self.title = title
        self.message = message
    }

    init(toastType: ToastType) {
        self.title = toastType.title
        self.message = toastType.message
    }
}
