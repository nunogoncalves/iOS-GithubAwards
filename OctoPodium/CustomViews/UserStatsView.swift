//
//  UserStatsView.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 30/03/2018.
//  Copyright © 2018 Nuno Gonçalves. All rights reserved.
//

import UIKit

final class UserStatsView: UIView {

    typealias SELF = UserStatsView

    private let leftSeperator = UIView.usingAutoLayout()
    private let repositoriesImageView = SELF.imageView(with: #imageLiteral(resourceName: "Repository"))
    private let repositoriesLabel = SELF.label

    private let reposAndStarsSeperator = UIView.usingAutoLayout()
    private let starsImageView = SELF.imageView(with: #imageLiteral(resourceName: "Star"))
    private let starsLabel = SELF.label

    private let starsAndLangsSeperator = UIView.usingAutoLayout()
    private let languagesImageView = SELF.imageView(with: #imageLiteral(resourceName: "Language"))
    private let languagesLabel = SELF.label

    private let langsAndMedalsSeperator = UIView.usingAutoLayout()
    private let medalsImageView = SELF.imageView(with: #imageLiteral(resourceName: "Medal"))
    private let medalsLabel = SELF.label

    private let rightSeperator = UIView.usingAutoLayout()

    private static var label: UILabel {
        let label = UILabel.usingAutoLayout()
        label.textColor = .white
        label.font = UIFont.TitilliumWeb.regular.ofSize(12)
        return label
    }

    private static func imageView(with image: UIImage) -> UIImageView {
        return create { $0.image = image }
    }

    private static var separator: UIView { return UIView.usingAutoLayout() }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        addSubviewsConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {

        addSubview(leftSeperator)
        addSubview(repositoriesImageView)
        addSubview(repositoriesLabel)

        addSubview(reposAndStarsSeperator)
        addSubview(starsImageView)
        addSubview(starsLabel)

        addSubview(starsAndLangsSeperator)
        addSubview(languagesImageView)
        addSubview(languagesLabel)

        addSubview(langsAndMedalsSeperator)
        addSubview(medalsImageView)
        addSubview(medalsLabel)

        addSubview(rightSeperator)
    }

    private func addSubviewsConstraints() {

        subviews.forEach { $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true }

        repositoriesImageView.constrain(width: 16, height: 20)
        [starsImageView, languagesImageView, medalsImageView].forEach { $0.constrainSize(equalTo: 20) }

        [leftSeperator, reposAndStarsSeperator, starsAndLangsSeperator, langsAndMedalsSeperator, rightSeperator].forEach {
            $0.constrain(height: 1)
        }

        [reposAndStarsSeperator, starsAndLangsSeperator, langsAndMedalsSeperator, rightSeperator].forEach {
            $0.widthAnchor.constraint(equalTo: leftSeperator.widthAnchor).isActive = true
        }

        self |- leftSeperator |-| repositoriesImageView |-| repositoriesLabel |-| reposAndStarsSeperator
        reposAndStarsSeperator |-| starsImageView |-| starsLabel |-| starsAndLangsSeperator
        starsAndLangsSeperator |-| languagesImageView |-| languagesLabel |-| langsAndMedalsSeperator
        langsAndMedalsSeperator |-| medalsImageView |-| medalsLabel |-| rightSeperator -| self
    }

    func render(with configuration: (repositories: Int?, stars: Int?, languages: Int?, medals: Int?)) {

        repositoriesLabel.text = configuration.repositories.stringValue
        starsLabel.text = configuration.stars.stringValue
        languagesLabel.text = configuration.languages.stringValue
        medalsLabel.text = configuration.medals.stringValue
    }
}

private extension Optional where Wrapped == Int {

    var stringValue: String {

        switch self {
        case let .some(wrapped): return "\(wrapped)"
        case .none: return "-"
        }
    }
}

precedencegroup EffectfulComposition {
    associativity: left
}

infix operator |-|: EffectfulComposition
@discardableResult
func |-|(left: UIView, right: UIView) -> UIView {
    left.trailingAnchor.constraint(equalTo: right.leadingAnchor).isActive = true
    return right
}

infix operator -|: EffectfulComposition
@discardableResult
func -|(left: UIView, right: UIView) -> UIView {
    left.trailingAnchor.constraint(equalTo: right.trailingAnchor).isActive = true
    return right
}

infix operator |-: EffectfulComposition
@discardableResult
func |-(left: UIView, right: UIView) -> UIView {
    left.leadingAnchor.constraint(equalTo: right.leadingAnchor).isActive = true
    return right
}

