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
        if let image = UIImage(named: "\(language.lowercaseString).png") {
            return image
        } else {
            return UIImage(named: "GenericLanguage.png")!
        }
    }
    
}
