//
//  FeedTextImageView.swift
//  PIMO
//
//  Created by 김영인 on 2023/02/21.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import Kingfisher

struct FeedTextImageView: View {
    private let postItem: FMPostItem
    
    init(postItem: FMPostItem) {
        self.postItem = postItem
    }
    
    var body: some View {
        KFImage(URL(string: postItem.imageUrl))
            .placeholder { Image(systemName: "person.fill") }
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

struct FeedTextImageView_Previews: PreviewProvider {
    static var previews: some View {
        FeedTextImageView(
            postItem: FMPostItem(
                imageUrl: FIMOStrings.textImage,
                content: "안녕"
            )
        )
    }
}
