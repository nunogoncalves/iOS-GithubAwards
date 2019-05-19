//
//  RankingCellHeader.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 10/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import UIKit

protocol RankingHeaderModelProtocol {
    var medals: Medals { get }
    var isPodium: Bool { get }
    var language: String { get }
    var numberOfStars: Int { get }
    var numberOfRepos: Int { get }
}

extension RankingPresenter: RankingHeaderModelProtocol {
    var isPodium: Bool { return hasMedals }
    var numberOfStars: Int { return stars }
    var numberOfRepos: Int { return repositories }
}


class RankingCellHeader: UIView {

    private enum RankingHeaderStyle {

        struct Style {
            let backgroundColor: UIColor
            let labelColor: UIColor
            let starImage: UIImage
            let reposImage: UIImage

            static let podiumStyle = Style(
                backgroundColor: UIColor(hex: 0x03436E),
                labelColor: .white,
                starImage: #imageLiteral(resourceName: "Star"),
                reposImage: #imageLiteral(resourceName: "Repository")
            )
            static let regularStyle = Style(
                backgroundColor: UIColor(hex: 0xE0E0E0),
                labelColor: UIColor(hex: 0x313131),
                starImage: #imageLiteral(resourceName: "StarDark"),
                reposImage: #imageLiteral(resourceName: "RepositoryDark")
            )
        }

        case podium
        case regular

        var properties: RankingHeaderStyle.Style {
            switch self {
            case .podium: return .podiumStyle
            case .regular: return .regularStyle
            }
        }
    }

    private var stackViewToLeadingConstraint: NSLayoutConstraint!
    private var stackViewToMedalsConstraint: NSLayoutConstraint!

    private let stackView: UIStackView = create {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 5
    }

    private let medalDisplay: MedalDisplayView = create {
        $0.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private let languageLabel: UILabel = create {
        $0.font = UIFont.systemFont(ofSize: 15)
    }

    private let starsImageView: UIImageView = create {
        $0.widthAnchor.constraint(equalToConstant: 20).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    private let starsLabel: UILabel = create {
        $0.font = UIFont.systemFont(ofSize: 17)
    }

    private let reposImageView: UIImageView = create {
        $0.widthAnchor.constraint(equalToConstant: 20).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 26).isActive = true
    }

    private let reposLabel: UILabel = create {
        $0.font = UIFont.systemFont(ofSize: 17)
    }

    override init(frame: CGRect) {

        super.init(frame: frame)

        addSubview(medalDisplay)
        addSubview(stackView)

        medalDisplay.constrain(referringTo: self, leading: 5, bottom: nil, trailing: nil)

        stackView.top(>=, topAnchor)
        stackView.bottom(<=, bottomAnchor)
        stackViewToLeadingConstraint = stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5)
        stackViewToMedalsConstraint = stackView.leadingAnchor.constraint(equalTo: medalDisplay.trailingAnchor)
        stackView.trailing(==, trailingAnchor, -15)
        stackView.centerY(==, centerYAnchor)

        stackView.addArrangedSubview(languageLabel)
        stackView.addArrangedSubview(starsImageView)
        stackView.addArrangedSubview(starsLabel)
        stackView.addArrangedSubview(reposImageView)
        stackView.addArrangedSubview(reposLabel)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(with model: RankingHeaderModelProtocol) {
        updateStyle(isPodium: model.isPodium)

        stackViewToLeadingConstraint.isActive = false
        stackViewToMedalsConstraint.isActive = false
        
        stackViewToLeadingConstraint.isActive = !model.isPodium
        stackViewToMedalsConstraint.isActive = !stackViewToLeadingConstraint.isActive
        layoutIfNeeded()

        medalDisplay.render(with: model.medals)
        languageLabel.text = "\(model.language) >"
        starsLabel.text = "\(model.numberOfStars)"
        reposLabel.text = "\(model.numberOfRepos)"
    }

    func reset() {
        medalDisplay.render(with: [])
        languageLabel.text = ""
        starsLabel.text = ""
        reposLabel.text = ""
    }

    private func updateStyle(isPodium: Bool) {
        let style: RankingHeaderStyle = isPodium ? .podium : .regular

        backgroundColor = style.properties.backgroundColor
        [languageLabel, starsLabel, reposLabel].forEach { $0.textColor = style.properties.labelColor }

        starsImageView.image = style.properties.starImage
        reposImageView.image = style.properties.reposImage
    }
}
