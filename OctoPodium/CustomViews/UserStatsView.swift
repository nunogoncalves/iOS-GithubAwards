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

    private let repositoriesStackView = SELF.stackView
    private let repositoriesLabel = UserStatsView.label

    private let starsStackView = SELF.stackView
    private let starsLabel = UserStatsView.label

    private let languagesStackView = SELF.stackView
    private let languagesLabel = UserStatsView.label

    private let medalsStackView = SELF.stackView
    private let medalsLabel = UserStatsView.label

    private static var stackView: UIStackView {

        let stackView = UIStackView.usingAutoLayout()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }

    private static var label: UILabel {
        let label = UILabel.usingAutoLayout()
        label.textColor = .white
        label.text = "-"
        label.backgroundColor = .red
        label.font = UIFont.TitilliumWeb.regular.ofSize(12)
        return label
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        addSubviewsConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {



        repositoriesStackView.addArrangedSubview(UIImageView(image: #imageLiteral(resourceName: "Repository")))
        repositoriesStackView.addArrangedSubview(repositoriesLabel)

        starsStackView.addArrangedSubview(UIImageView(image: #imageLiteral(resourceName: "Star")))
        starsStackView.addArrangedSubview(starsLabel)

        languagesStackView.addArrangedSubview(UIImageView(image: #imageLiteral(resourceName: "Language")))
        languagesStackView.addArrangedSubview(languagesLabel)

        medalsStackView.addArrangedSubview(UIImageView(image: #imageLiteral(resourceName: "Medal")))
        medalsStackView.addArrangedSubview(medalsLabel)

        addSubview(repositoriesStackView)
        addSubview(starsStackView)
        addSubview(languagesStackView)
        addSubview(medalsStackView)
    }

    private func addSubviewsConstraints() {

        NSLayoutConstraint.activate([

            repositoriesStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            starsStackView.leadingAnchor.constraint(equalTo: repositoriesStackView.trailingAnchor),

            languagesStackView.leadingAnchor.constraint(equalTo: starsStackView.trailingAnchor),

            medalsStackView.leadingAnchor.constraint(equalTo: languagesStackView.trailingAnchor),
            medalsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        [repositoriesStackView, starsStackView, languagesStackView, medalsStackView].forEach {

            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: topAnchor),
                $0.bottomAnchor.constraint(equalTo: bottomAnchor),
                $0.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1 / 4),
                $0.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])

            let imageView = $0.arrangedSubviews.first!
            imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
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
