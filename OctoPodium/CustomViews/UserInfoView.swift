//
//  UserInfoView.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 19/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation

final class UserInfoView: UIView {

    private let avatarIdentityTransform: CGAffineTransform
    private var avatarYConstraint: NSLayoutConstraint!
    private var avatarXConstraint: NSLayoutConstraint!

    private let avatarYFunction = linearFunction(
        for: CGPoint(x: .minHeight, y: -.avatarSmallSize / 2 + .avatarTopSpacingAtMinHeight),
        and: CGPoint(x: .maxHeight, y: .avatarTopSpacingAtMaxHeight)
    )

    private var avatarXFunction: LinearFunction {
        let positionAtMinHeight: CGFloat = -(width / 2) + .avatarSmallSize / 2 + .margin
        return linearFunction(
            for: CGPoint(x: .minHeight, y: positionAtMinHeight),
            and: CGPoint(x: .maxHeight, y: 0)
        )
    }

    private let avatarScaleFunction = linearFunction(
        for: CGPoint(x: .minHeight, y: .minimumAvatarScale),
        and: CGPoint(x: .maxHeight, y: 1)
    )

    private let avatarBackground: UIView = create {
        $0.backgroundColor = .white
        $0.cornerRadius = .avatarBigSize / 2
        UIView.set($0.widthAnchor, .avatarBigSize)
        UIView.set($0.heightAnchor, .avatarBigSize)
    }

    private let avatarImageView: UIImageView = create {
        $0.cornerRadius = .avatarImageSize / 2
        UIView.set($0.widthAnchor, .avatarImageSize)
        UIView.set($0.heightAnchor, .avatarImageSize)
    }

    private let locationLabelIdentityTransform: CGAffineTransform
    private var locationLabelYConstraint: NSLayoutConstraint!
    private var locationLabelXConstraint: NSLayoutConstraint!

    private let locationLabel: UILabel = create {
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = .white
        $0.textAlignment = .center
    }

    private var locationLabelScaleFunction: LinearFunction {
        let witdhRatioAtMinHeight = locationLabelWidthSpaceRatio < 1 ? 1 : 1 / locationLabelWidthSpaceRatio
        return linearFunction(
            for: CGPoint(x: .minHeight, y: witdhRatioAtMinHeight),
            and: CGPoint(x: .maxHeight, y: 1)
        )
    }

    private var locationLabelWidthSpaceRatio: CGFloat {
        let availableSpace = width - (.margin * 2 + .avatarSmallSize + .space * 2 + githubButton.width)
        return locationLabel.width / availableSpace
    }

    private let locationYFunction = linearFunction(
        for: CGPoint(x: .minHeight, y: 0),
        and: CGPoint(x: .maxHeight, y: 62)
    )

    private var locationXFunction: LinearFunction {
        return linearFunction(
            for: CGPoint(x: .minHeight, y: .avatarSmallSize / 2 + .space + locationLabel.width / 2),
            and: CGPoint(x: .maxHeight, y: 0)
        )
    }

    private var githubButtonYConstraint: NSLayoutConstraint!
    private var githubButtonXConstraint: NSLayoutConstraint!

    private let githubButtonYFunction = linearFunction(
        for: CGPoint(x: .minHeight, y: 0),
        and: CGPoint(x: .maxHeight, y: 50)
    )

    private var githubButtonXFunction: LinearFunction {
        return linearFunction(
            for: CGPoint(x: .minHeight, y: frame.width / 2 - githubButton.width / 2 - .margin),
            and: CGPoint(x: .maxHeight, y: 0)
        )
    }

    private let githubButton: UIButton = create {
        $0.setTitle("View on Github", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        $0.backgroundColor = UIColor(hex: 0x43A5E7)
        $0.cornerRadius = 5
        $0.setTitleColor(.white, for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }

    private let userStatsAlphaFunc = linearFunction(
        for: CGPoint(x: .minHeight, y: 0),
        and: CGPoint(x: .maxHeight, y: 1)
    )
    private let userStats: UserStatsView = create {
        UIView.set($0.heightAnchor, 20)
    }

    private var heightConstraint: NSLayoutConstraint!

    func setHeight(_ height: CGFloat) {

        guard height >= .minHeight, height <= .maxHeight else { return }
        heightConstraint.constant = height

        let avatarScale = avatarScaleFunction(height)
        avatarBackground.transform = avatarIdentityTransform.scaledBy(x: avatarScale, y: avatarScale)
        avatarYConstraint.constant = avatarYFunction(height)
        avatarXConstraint.constant = avatarXFunction(height)

        let locationLabelScale = locationLabelScaleFunction(height)
        locationLabel.transform = locationLabelIdentityTransform.scaledBy(x: locationLabelScale, y: locationLabelScale)
        locationLabelYConstraint.constant = locationYFunction(height)
        locationLabelXConstraint.constant = locationXFunction(height)

        githubButtonYConstraint.constant = githubButtonYFunction(height)
        githubButtonXConstraint.constant = githubButtonXFunction(height)

        userStats.alpha = userStatsAlphaFunc(height)
    }

    override init(frame: CGRect) {

        avatarIdentityTransform = avatarBackground.transform
        locationLabelIdentityTransform = locationLabel.transform

        super.init(frame: frame)

        addSubview(avatarBackground)
        avatarBackground.addSubview(avatarImageView)
        addSubview(githubButton)
        addSubview(locationLabel)
        addSubview(userStats)

        heightAnchor.constraint(greaterThanOrEqualToConstant: .minHeight).isActive = true
        heightAnchor.constraint(lessThanOrEqualToConstant: .maxHeight).isActive = true
        heightConstraint = heightAnchor.constraint(equalToConstant: .maxHeight)
        heightConstraint.isActive = true

        avatarXConstraint = avatarBackground.centerX(==, self)
        avatarYConstraint = avatarBackground.top(==, self, .margin)

        avatarImageView.centerX(==, avatarBackground)
        avatarImageView.centerY(==, avatarBackground)

        // 1/2 avatar + space + 1/2 height
        locationLabelYConstraint = locationLabel.centerY(==, avatarBackground, .avatarBigSize / 2 + .space + .textsHeight / 2)
        locationLabelXConstraint = locationLabel.centerX(==, avatarBackground)
        locationLabel.leading(>=, self, .margin)
        locationLabel.trailing(<=, self, -.margin)

        githubButtonYConstraint = githubButton.centerY(==, locationLabel, .textsHeight / 2 + .space + .textsHeight / 2)
        githubButtonXConstraint = githubButton.centerX(==, self)
        githubButton.leading(>=, self, .margin)
        githubButton.trailing(<=, self, -.margin)

        userStats.centerX(==, self)
        userStats.bottom(==, self, -.margin)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(with userPresenter: UserPresenter) {
        loadAvatar(userPresenter)
        userStats.render(with: userPresenter.rankingInfo)
        locationLabel.text = userPresenter.fullLocation
    }

    private func loadAvatar(_ presenter: UserPresenter) {
        guard let avatarUrl = presenter.avatarUrl, avatarUrl != "" else { return }
        avatarImageView.fetchAndLoad(avatarUrl) {
//            self.loading.stopAnimating()
        }
    }
}

private extension CGFloat {
    static let minHeight: CGFloat = 50
    static let maxHeight: CGFloat = 190
    static let minimumAvatarScale: CGFloat = 0.5
    static let avatarBigSize: CGFloat = 80
    static let avatarSmallSize: CGFloat = avatarBigSize * minimumAvatarScale
    static let avatarImageSize: CGFloat = avatarBigSize - 4

    static let avatarTopSpacingAtMaxHeight: CGFloat = 10
    static let avatarTopSpacingAtMinHeight: CGFloat = 5

    static let space: CGFloat = 5
    static let textsHeight: CGFloat = 30

    static let margin: CGFloat = 10
}
