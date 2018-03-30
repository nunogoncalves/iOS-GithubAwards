//
//  NewGithubButton.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 30/03/2018.
//  Copyright © 2018 Nuno Gonçalves. All rights reserved.
//

import UIKit

final class NewGithubButton: UIView {

    private let imageAndTitleStackView: UIStackView = {

        let stackView = UIStackView.usingAutoLayout()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()

    private let symbolImageViewContainer = UIView.usingAutoLayout()

    private let symbolImageView: UIImageView = {

        let imageView = UIImageView.usingAutoLayout()
        imageView.contentMode = .scaleToFill

        return imageView
    }()
    private let titleLabel = NewGithubButton.label
    private let gradientView = UIView.usingAutoLayout()
    private let separator = UIView.usingAutoLayout()
    private let valueLabel = NewGithubButton.label

    private static var label: UILabel {
        let label = UILabel.usingAutoLayout()
        label.textAlignment = .center
        label.font = UIFont.TitilliumWeb.regular.ofSize(.fontSize)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = .minimumTextScaleFactor
        return label
    }

    let loadingView = GithubLoadingView.usingAutoLayout()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        clipsToBounds = true
        borderColor = UIColor(hex: 0xD5D5D5)
        borderWidth = .borderWidth
        layer.cornerRadius = .cornerRadius

        addSubviews()
        addSubviewsConstraints()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {

        addSubview(gradientView)

        addSubview(imageAndTitleStackView)

        symbolImageViewContainer.addSubview(symbolImageView)

        imageAndTitleStackView.addArrangedSubview(symbolImageViewContainer)
        imageAndTitleStackView.addArrangedSubview(titleLabel)

        separator.backgroundColor = .borderColor
        addSubview(separator)
        addSubview(valueLabel)
        valueLabel.hide()

        addSubview(loadingView)
    }

    private func addSubviewsConstraints() {

        NSLayoutConstraint.activate([

            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.topAnchor.constraint(equalTo: topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),

            imageAndTitleStackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            imageAndTitleStackView.centerXAnchor.constraint(equalTo: gradientView.centerXAnchor),
            imageAndTitleStackView.topAnchor.constraint(equalTo: topAnchor),
            imageAndTitleStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            symbolImageViewContainer.centerXAnchor.constraint(equalTo:
                symbolImageView.centerXAnchor),
            symbolImageViewContainer.centerYAnchor.constraint(equalTo:
                symbolImageView.centerYAnchor),
            symbolImageViewContainer.widthAnchor.constraint(equalTo: symbolImageView.widthAnchor),

            symbolImageView.widthAnchor.constraint(equalToConstant: .imagesWidth),
            symbolImageView.heightAnchor.constraint(equalToConstant: .imagesHeight),

            separator.leadingAnchor.constraint(equalTo: gradientView.trailingAnchor),
            separator.widthAnchor.constraint(equalToConstant: .seperatorWidth),
            separator.topAnchor.constraint(equalTo: topAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),

            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: separator.trailingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10),
            valueLabel.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.4, constant: -20),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            loadingView.widthAnchor.constraint(equalToConstant: .imagesWidth),
            loadingView.heightAnchor.constraint(equalToConstant: .imagesHeight),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: valueLabel.centerXAnchor)
        ])
    }

    private func applyGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = gradientView.bounds
        gradient.colors = [
            UIColor(hex: 0xFCFCFC).cgColor,
            UIColor(hex: 0xEEEEEE).cgColor
        ]
        gradientView.layer.insertSublayer(gradient, at: 0)
    }

    func render(with configuration: Configuration) {

        switch configuration {

        case let .full(image, title, value):

            symbolImageView.image = image
            titleLabel.text = title
            valueLabel.text = value

        case let .update(title, value):

            titleLabel.text = title
            valueLabel.text = value

        case let .updateValue(value):

            valueLabel.text = value

        case let .updateTitle(title):

            titleLabel.text = title
            
        case .startLoading:

            loadingView.show()
            loadingView.setLoading()
            valueLabel.hide()

        case .stopLoading:

            loadingView.hide()
            loadingView.stop()
            valueLabel.show()
        }

        layoutIfNeeded()
        gradientView.layer.sublayers = nil
        applyGradient()
    }

    enum Configuration {

        case full(image: UIImage, title: String, value: String)
        case update(title: String, value: String)
        case updateValue(_: String)
        case updateTitle(_: String)
        case startLoading
        case stopLoading
    }
}

private extension UIColor {

    static let borderColor = UIColor(hex: 0xD5D5D5)
}

private extension CGFloat {

    static let borderWidth: CGFloat = 2
    static let fontSize: CGFloat = 14
    static let cornerRadius: CGFloat = 5
    static let minimumTextScaleFactor: CGFloat = 0.4
    static let imagesWidth: CGFloat = 20
    static let imagesHeight: CGFloat = 20
    static let seperatorWidth: CGFloat = 2
}
