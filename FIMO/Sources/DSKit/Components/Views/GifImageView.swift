//
//  GifImageView.swift
//  FIMO
//
//  Created by 김영인 on 2023/03/20.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

import FLAnimatedImage

struct GifImageView: UIViewRepresentable {
    
    let animatedView = FLAnimatedImageView(frame: CGRect(x: 0, y: 0, width: 82, height: 23))
    var fileName: String
    
    func makeUIView(context: UIViewRepresentableContext<GifImageView>) -> some UIView {
        let view = UIView()
        
        let path = Bundle.main.path(forResource: fileName, ofType: "gif")!
        let url = URL(fileURLWithPath: path)
        let gifData = try! Data(contentsOf: url)
        
        let gif = FLAnimatedImage(animatedGIFData: gifData)
        animatedView.animatedImage = gif
        animatedView.contentMode = UIView.ContentMode.scaleToFill
        view.addSubview(animatedView)
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
