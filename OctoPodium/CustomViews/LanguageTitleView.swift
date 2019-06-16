//
//  LanguageTitleView.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 03/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit
import Xtensions

class LanguageTitleView: UIView {

    private let stackView: UIStackView = create {
        $0.spacing = 5
    }

    private let languageImageView: LanguageImageView = create {
        $0.widthAnchor.constraint(equalToConstant: 30).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    private let nameLabel: UILabel = create {
        $0.textColor = .white
        $0.font = UIFont.boldSystemFont(ofSize: 17)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(stackView)
        stackView.addArrangedSubview(languageImageView)
        stackView.addArrangedSubview(nameLabel)

        stackView.centerX(==, centerXAnchor)
        stackView.centerY(==, centerYAnchor)
        stackView.leading(>=, leadingAnchor, 5)
        stackView.trailing(<=, trailingAnchor, -5)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(with language: String) {
        nameLabel.text = language
        languageImageView.render(with: language)
    }
}
