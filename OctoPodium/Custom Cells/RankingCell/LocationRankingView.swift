//
//  LocationRankingView.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 12/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import UIKit

protocol LocationRankingProtocol {
    var worldRanking: WorldRanking { get }
    var countryRanking: CountryRanking? { get }
    var cityRanking: CityRanking? { get }
}

extension RankingProtocol {

    var formattedDescription: NSAttributedString {
        let attributedString = NSMutableAttributedString(
            string: "\(position)",
            attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
            ]
        )

        attributedString.append(
            NSAttributedString(
                string: "/\(total)",
                attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                ]
            )
        )
        return attributedString
    }
}

final class LocationRankingView: UIView {

    private typealias SELF = LocationRankingView

    private let stackView: UIStackView = create {
        $0.axis = .vertical
        $0.spacing = 15
        $0.distribution = .equalSpacing
    }

    private let cityStack = SELF.locationStackView
    private let cityLabel = SELF.nameLabel
    private let cityRankingLabel = UILabel.usingAutoLayout()

    private let countryStack: UIStackView = SELF.locationStackView
    private let countryLabel = SELF.nameLabel
    private let countryRankingLabel = UILabel.usingAutoLayout()

    private let worldStack: UIStackView = SELF.locationStackView
    private let worldLabel = SELF.nameLabel
    private let worldRankingLabel = UILabel.usingAutoLayout()

    private static var locationStackView: UIStackView {
        return create {
            $0.axis = .horizontal
            $0.distribution = .fill
            $0.spacing = 10
        }
    }

    private static var nameLabel: UILabel {
        return create {
            $0.textColor = UIColor(hex: 0x858585)
            $0.font = UIFont.systemFont(ofSize: 13)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(stackView)
        stackView.addArrangedSubview(cityStack)
        stackView.addArrangedSubview(countryStack)
        stackView.addArrangedSubview(worldStack)

        worldStack.addArrangedSubview(worldLabel)
        worldLabel.text = "Worldwide"
        worldStack.addArrangedSubview(worldRankingLabel)
        worldRankingLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        countryStack.addArrangedSubview(countryLabel)
        countryStack.addArrangedSubview(countryRankingLabel)
        countryRankingLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        cityStack.addArrangedSubview(cityLabel)
        cityStack.addArrangedSubview(cityRankingLabel)
        cityRankingLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        self.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        stackView.constrain(referringTo: layoutMarginsGuide , bottom: nil)
        stackView.bottom(<=, layoutMarginsGuide.bottomAnchor)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(with presenter: LocationRankingProtocol) {
        worldRankingLabel.attributedText = presenter.worldRanking.formattedDescription

        countryStack.isHidden = presenter.countryRanking == nil
        countryLabel.text = presenter.countryRanking?.name
        countryRankingLabel.attributedText = presenter.countryRanking?.formattedDescription

        cityStack.isHidden = presenter.cityRanking == nil
        cityLabel.text = presenter.cityRanking?.name
        cityRankingLabel.attributedText = presenter.cityRanking?.formattedDescription
    }
}
