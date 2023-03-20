//
//  ImagePicker.swift
//  PIMO
//
//  Created by Ok Hyeon Kim on 2023/02/18.
//  Copyright © 2023 pimo. All rights reserved.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController

    @Environment(\.presentationMode)
    private var presentationMode
    let imagePicked: (UIImage) -> Void

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.editedImage] as? UIImage,
               let croppedImage = cropImageToSquare(image) {

                let resizedImage = resizeImage(croppedImage).downSample()
                parent.imagePicked(resizedImage)
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }

        private func cropImageToSquare(_ uiImage: UIImage) -> UIImage? {
            let sideLength = min(uiImage.size.width, uiImage.size.height)

            let sourceSize = uiImage.size
            let xOffset = (sourceSize.width - sideLength) / 2.0
            let yOffset = (sourceSize.height - sideLength) / 2.0

            let cropRect = CGRect( x: xOffset, y: yOffset, width: sideLength, height: sideLength).integral

            guard let sourceCGImage = uiImage.cgImage,
                  let croppedCGImage = sourceCGImage.cropping(to: cropRect) else {
                parent.presentationMode.wrappedValue.dismiss()
                return nil
            }

            let croppedImage = UIImage(cgImage: croppedCGImage)

            return croppedImage
        }

        private func resizeImage(_ uiImage: UIImage) -> UIImage {
            guard uiImage.size.width > 1000 else {
                return uiImage
            }

            return uiImage.resize(newWidth: 1000)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {

        let picker = UIImagePickerController()

        picker.delegate = context.coordinator
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary

        return picker

    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
}
