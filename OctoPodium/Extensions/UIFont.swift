//
//  UIFont.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 09/12/2017.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import Foundation

protocol Fontable {

    var rawValue: String { get }
    func ofSize(_ size: CGFloat) -> UIFont
}

extension Fontable {

    func ofSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: rawValue, size: size)!
    }
}

extension UIFont {

    enum TitilliumWeb : String, Fontable {

        case black = "TitilliumWeb-Black"
        case bold = "TitilliumWeb-Bold"
        case boldItalic = "TitilliumWeb-BoldItalic"
        case extraLight = "TitilliumWeb-ExtraLight"
        case extraLightItalic = "TitilliumWeb-ExtraLightItalic"
        case italic = "TitilliumWeb-Italic"
        case light = "TitilliumWeb-Light"
        case lightItalic = "TitilliumWeb-LightItalic"
        case regular = "TitilliumWeb-Regular"
        case semibold = "TitilliumWeb-SemiBold"
        case semiBoldItalic = "TitilliumWeb-SemiBoldItalic"
    }
}
