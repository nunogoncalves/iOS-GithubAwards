//
//  LanguageImage.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 04/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class LanguageImage : UIImage {

    class func loadFor(language: String) -> UIImage {
        if let image = UIImage(named: language.lowercaseString) {
            return image
        } else {
            return UIImage(named: "Language")!
        }
    }
    
    class func loadForOr(language: String, orLabel label: UILabel) -> UIImage {
        if language == "" { return UIImage(named: "Language")! }
        
        if let image = UIImage(named: language.lowercaseString) {
            return image
        } else {
            UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
            label.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    }
    
}
