//
//  ArchiveEmptyView.swift
//  PIMOTests
//
//  Created by 김영인 on 2023/02/26.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

struct ArchiveEmptyView: View {
    var archiveType: ArchiveType
    
    var body: some View {
        VStack {
            Image(uiImage: PIMOAsset.Assets.feedEmpty.image)
            
            Spacer()
                .frame(height: 16)
            
            Text(PIMOStrings.emptyFeed)
                .font(Font(PIMOFontFamily.Pretendard.medium.font(size: 19)))
                .foregroundColor(.black)
            
            Spacer()
                .frame(height: 23)
            
            if archiveType == .myArchive {
                Text(PIMOStrings.emptyFeedGuide)
                    .font(Font(PIMOFontFamily.Pretendard.light.font(size: 14)))
                    .foregroundColor(Color(PIMOAsset.Assets.grayText.color))
            }
        }
    }
}

struct ArchiveEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveEmptyView(
            archiveType: .myArchive)
    }
}
