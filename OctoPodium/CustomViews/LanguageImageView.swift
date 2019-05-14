//
//  LanguageImageView.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 11/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class LanguageImageView: UIView {

    private let imageView = UIImageView.usingAutoLayout()

    private let label: UILabel = create {
        $0.textColor = .white
        $0.backgroundColor = UIColor(hex: 0x2F9DE6)
        $0.textAlignment = .center
        $0.cornerRadius = 15
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(imageView)
        addSubview(label)

        imageView.pinToBounds(of: self)
        label.pinToBounds(of: self)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(with language: String) {
        var lang = language
        if lang == "" { lang = "Language" }
        if let image = UIImage(named: lang.lowercased()) {
            imageView.image = image
            imageView.show()
            label.hide()
        } else {
            imageView.hide()
            label.show()
            label.text = "\(lang.first!)"
        }
    }
}
