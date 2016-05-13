//
//  UIImageView.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 13/05/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    func fetchAndLoad(url: String, onFinished: () -> () = {}) {
        let url = NSURL(string: url)!
        sd_setImageWithURL(url) { (_, _, _, _) in
            onFinished()
        }
    }
}
