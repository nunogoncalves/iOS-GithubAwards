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
    
    func fetchAndLoad(_ url: String, onFinished: () -> () = {}) {
        let url = URL(string: url)!
        sd_setImage(with: url) { (_, _, _, _) in
            onFinished()
        }
    }
}
