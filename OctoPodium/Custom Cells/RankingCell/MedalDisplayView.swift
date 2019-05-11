//
//  MedalDisplayView.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 10/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import UIKit

class MedalDisplayView: UIView {

    private let stackView: UIStackView = create {
        $0.axis = .horizontal
        $0.spacing = -17
    }

    private func imageView(with image: UIImage) -> UIImageView {
        return create {
            $0.image = image
            $0.widthAnchor.constraint(equalToConstant: 26).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(stackView)
        stackView.top(>=, topAnchor)
        stackView.leading(>=, leadingAnchor)
        stackView.bottom(<=, bottomAnchor)
        stackView.trailing(<=, trailingAnchor)
        stackView.centerX(==, centerXAnchor)
        stackView.centerY(==, centerYAnchor)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(with medals: Medals) {

        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            stackView.removeAllSubviews()
        }
        if medals.contains(.gold) {
            stackView.addArrangedSubview(imageView(with: #imageLiteral(resourceName: "GoldMedal")))
        }
        if medals.contains(.silver) {
            stackView.addArrangedSubview(imageView(with: #imageLiteral(resourceName: "SilverMedal")))
        }
        if medals.contains(.bronze) {
            stackView.addArrangedSubview(imageView(with: #imageLiteral(resourceName: "BronzeMedal")))
        }
    }
}

