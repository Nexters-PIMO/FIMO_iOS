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
    private let textImage: FMPostItem
    
    init(textImage: FMPostItem) {
        self.textImage = textImage
    }
    
    var body: some View {
        KFImage(URL(string: textImage.imageURL))
            .placeholder { Image(systemName: "person.fill") }
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

struct FeedTextImageView_Previews: PreviewProvider {
    static var previews: some View {
        FeedTextImageView(textImage: FMPostItem(
            id: "",
            imageURL: FIMOStrings.textImage,
            text: "안녕"))
    }
}
