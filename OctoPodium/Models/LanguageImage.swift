//
//  LanguageImage.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 04/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class LanguageImage : UIImage {

    class func loadFor(_ language: String) -> UIImage {
        if let image = UIImage(named: language.lowercased()) {
            return image
        } else {
            return UIImage(named: "Language")!
        }
    }
    
    class func load(for language: String, orLanguageImageView languageImageView: LanguageImageView) -> UIImage {
        if language == "" { return #imageLiteral(resourceName: "Language") }
        
        if let image = UIImage(named: language.lowercased()) {
            return image
        } else {
            UIGraphicsBeginImageContextWithOptions(languageImageView.bounds.size, false, 0.0)
            languageImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image!
        }
    }
    
}
