//
//  LanguageImageView.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 11/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class LanguageImageView : UIView {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var language: Language? {
        didSet {
            if let language = language {
                if let image = UIImage(named: language.lowercaseString) {
                    imageView.image = image
                    imageView.show()
                    label.hide()
                } else {
                    imageView.hide()
                    label.show()
                    label.text = "\(language.characters.first!)"
                }
            } else {
                label.text = " "
                label.show()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        container.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        NSBundle.mainBundle().loadNibNamed("LanguageImageView", owner: self, options: nil)
        addSubview(container)
    }
}
