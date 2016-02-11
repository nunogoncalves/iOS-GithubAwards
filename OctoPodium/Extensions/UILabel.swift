//
//  UILabel.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 11/02/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

extension UILabel {
    
    var substituteFontName : String {
        get { return font.fontName }
        set { font = UIFont(name: newValue, size: font.pointSize) }
    }
    
}
