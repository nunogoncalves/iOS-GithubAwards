//
//  LanguageImageView.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 11/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class LanguageImageView : UIView, NibView {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var language: Language? {
        didSet {
            setLanguageIconOrLetter()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        view.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func afterCommonInit() {}
    
    private func setLanguageIconOrLetter() {
        if var lang = language {
            if lang == "" { lang = "Language" }
            if let image = UIImage(named: lang.lowercaseString) {
                imageView.image = image
                imageView.show()
                label.hide()
            } else {
                imageView.hide()
                label.show()
                label.text = "\(lang.characters.first!)"
            }
        } else {
            label.text = " "
            label.show()
        }
    }
}
