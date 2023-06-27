//
//  LoadingView.swift
//  PIMO
//
//  Created by 김영인 on 2023/03/29.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    var hasOpacity: Bool = false

    var body: some View {
        ZStack {
            if hasOpacity {
                Rectangle()
                    .foregroundColor(.black)
                    .opacity(0.3)
            } else {
                Rectangle()
                    .foregroundColor(.white)
            }
            
            VStack {
                Spacer()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(FIMOAsset.Assets.orange.color)))
                    .scaleEffect(2)
                
                Spacer()
                
                Spacer()
                    .frame(height: 72)
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
