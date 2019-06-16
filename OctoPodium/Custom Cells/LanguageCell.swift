//
//  LanguageCell.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 04/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit
import Xtensions

class LanguageCell: UITableViewCell, Reusable {

    private let languageImageView: LanguageImageView = create {
        $0.widthAnchor.constraint(equalToConstant: 30).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    private let nameLabel: UILabel = create {
        $0.textColor = UIColor(hex: 0x565656)
        $0.font = UIFont.systemFont(ofSize: 17)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(languageImageView)
        contentView.addSubview(nameLabel)

        languageImageView.centerY(==, contentView.centerYAnchor)
        languageImageView.leading(==, contentView.leadingAnchor, 16)

        nameLabel.leading(==, languageImageView.trailingAnchor, 15)
        nameLabel.centerY(==, languageImageView.centerYAnchor)
        nameLabel.trailing(==, contentView.trailingAnchor)
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
