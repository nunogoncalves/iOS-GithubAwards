//
//  ImageLoader.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

class ImageLoader {

    static func fetchAndLoad(url: String, imageView: UIImageView, onFinished: () -> () = {}) {
        let url = NSURL(string: url)!
        imageView.sd_setImageWithURL(url) { (_, _, _, _) in
            onFinished()
        }
    }
}
