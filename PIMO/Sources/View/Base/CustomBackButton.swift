//
//  CustomBackButton.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/03/03.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

struct CustomBackButton: View {
    @Environment(\.presentationMode) var presentation

    var body: some View {
        Button {
            presentation.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 12))
                .foregroundColor(.black)
                .bold()
        }
    }
}

struct CustomBackButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomBackButton()
    }
}
