//
//  UIImage+.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/18.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }

        return renderImage
    }

    func downSample() -> UIImage {
        let scale = UIScreen.main.scale
        let size = CGSize(width: self.size.width / 3, height: self.size.height / 3)

        let imageSourceOption = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let data = self.pngData(),
              let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOption) else {
            return self
        }

        let maxPixel = max(size.width, size.height) * scale
        let downSampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixel
        ] as CFDictionary

        let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSampleOptions)!

        let newImage = UIImage(cgImage: downSampledImage)
        
        return newImage
    }
}
