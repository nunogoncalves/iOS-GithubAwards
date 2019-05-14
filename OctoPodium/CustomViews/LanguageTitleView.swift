//
//  LanguageTitleView.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 03/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class LanguageTitleView: UIView {

    @IBOutlet weak var topLevelSubView: UIView!
    @IBOutlet weak var languageImageView: LanguageImageView!
    @IBOutlet weak var name: UILabel!

    var language: String? {
        didSet {
            let lang = language ?? ""
            name.text = lang
            languageImageView.render(with: lang)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        topLevelSubView.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("LanguageTitleView", owner: self, options: nil)
        addSubview(topLevelSubView)
    }
    
}
