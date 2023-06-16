//
//  AcknowListView.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/03/18.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import AcknowList

struct AcknowListView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        AcknowListViewController()

    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
