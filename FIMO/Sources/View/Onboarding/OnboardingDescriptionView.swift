//
//  OnboardingDescriptionView.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/14.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

struct OnboardingDescriptionView: View {
    let type: OnboardingPageType

    var body: some View {
        VStack(spacing: 0) {
            LazyVStack(alignment: .leading, spacing: 0) {
                if type != .one {
                    Text(type.categoryTitle)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(FIMOAsset.Assets.red1.color))
                        .padding(.bottom, 12)
                } 

                HStack(alignment: .bottom, spacing: 0) {
                    Text(type.title)
                        .font(.system(size: 25, weight: .bold))
                        .lineSpacing(8)

                    if type == .one {
                        Image(uiImage: FIMOAsset.Assets.whitefimo.image)
                            .resizable()
                            .frame(width: 72, height: 20)
                            .padding([.bottom, .leading], 4)
                    }
                }
                .padding(.bottom, 19)

                Text(type.body)
                    .font(.system(size: 15))
                    .lineSpacing(8)
            }
            .minimumScaleFactor(0.01)
            .foregroundColor(type == .one ? .white : .black)
            .padding(.leading, 40)
            .padding(.trailing, 20)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 39)
    }
}

struct OnboardingDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingDescriptionView(type: .one)
        OnboardingDescriptionView(type: .two)
        OnboardingDescriptionView(type: .three)
        OnboardingDescriptionView(type: .four)
    }
}
