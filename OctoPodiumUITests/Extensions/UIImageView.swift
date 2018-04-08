//
//  UIImageView.swift
//  OctoPodiumUITests
//
//  Created by Nuno Gonçalves on 07/04/2018.
//  Copyright © 2018 Nuno Gonçalves. All rights reserved.
//

import UIKit

// Taken from: https://medium.com/@joesusnick/snapshot-xcui-testing-6a16c7ccd47b

extension UIImage {

    var removingStatusBar: UIImage? {

        guard let cgImage = cgImage else { return nil }

        let yOffset = 22 * scale // status bar height on standard devices (not iPhoneX)

        let rect = CGRect(
            x: 0,
            y: Int(yOffset),
            width: cgImage.width,
            height: cgImage.height - Int(yOffset)
        )

        if let croppedCGImage = cgImage.cropping(to: rect) {
            return UIImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
        }

        return nil
    }
}
