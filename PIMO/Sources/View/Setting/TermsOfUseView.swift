//
//  TermsOfUseView.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/27.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

struct TermsOfUseView: View {
    var body: some View {
        TextViewContainer(text: PIMOStrings.termsOfUse)
            .navigationTitle("개인 정보 처리 방침 / 이용약관")
    }
}

struct TextViewContainer: UIViewRepresentable {
    let text: String

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.font = .systemFont(ofSize: 16)
        view.isScrollEnabled = true
        view.isEditable = false
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = self.text
    }

    typealias UIViewType = UITextView
}

struct TermsOfUseView_Previews: PreviewProvider {
    static var previews: some View {
        TermsOfUseView()
    }
}
