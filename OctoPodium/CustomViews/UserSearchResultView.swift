//
//  UserSearchResultView.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 16/06/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import UIKit
import Xtensions

final class UserSearchResultView: UIView {

    private let octoCatImageView: UIImageView = create {
        $0.image = #imageLiteral(resourceName: "OctoCat")
        $0.constrainSize(equalTo: 200)
    }

    private let leftEyeImageView: UIImageView = create {
        $0.image = #imageLiteral(resourceName: "EyeBall")
    }

    private let rightEyeImageView: UIImageView = create {
        $0.image = #imageLiteral(resourceName: "EyeBall")
    }

    private var eyeWidthConstraint: NSLayoutConstraint
    private var eyeHeightConstraint: NSLayoutConstraint

    private var leadingEyeConstraint: NSLayoutConstraint!
    private var topEyeConstraint: NSLayoutConstraint!
    private var trailingEyeConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {

        eyeWidthConstraint = leftEyeImageView.constrain(width: .foundEyeWidth)
        eyeHeightConstraint = leftEyeImageView.constrain(height: .foundEyeHeight)

        super.init(frame: frame)

        addSubviews(
            octoCatImageView,
            leftEyeImageView,
            rightEyeImageView
        )

        octoCatImageView.center(==, self)

        leadingEyeConstraint = leftEyeImageView.leading(==, self, .foundEyesMargin)
        topEyeConstraint = leftEyeImageView.top(==, self, .foundEyesTopMargin)
        trailingEyeConstraint = rightEyeImageView.trailing(==, self, -.foundEyesMargin)
        leftEyeImageView.top(==, rightEyeImageView)

        rightEyeImageView.width(==, leftEyeImageView)
        rightEyeImageView.height(==, leftEyeImageView)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(found: Bool) {
        if found {
            leftEyeImageView.image = #imageLiteral(resourceName: "EyeBall")
            rightEyeImageView.image = #imageLiteral(resourceName: "EyeBall")
            eyeWidthConstraint.constant = .foundEyeWidth
            eyeHeightConstraint.constant = .foundEyeHeight

            leadingEyeConstraint.constant = .foundEyesMargin
            topEyeConstraint.constant = .foundEyesTopMargin
            trailingEyeConstraint.constant = -.foundEyesMargin

        } else {
            leftEyeImageView.image = #imageLiteral(resourceName: "X")
            rightEyeImageView.image = #imageLiteral(resourceName: "X")
            eyeWidthConstraint.constant = .notFoundEyeWidth
            eyeHeightConstraint.constant = .notFoundEyeHeight

            leadingEyeConstraint.constant = .notFoundEyesMargin
            topEyeConstraint.constant = .notFoundEyesTopMargin
            trailingEyeConstraint.constant = -.notFoundEyesMargin
        }
    }
}

private extension CGFloat {
    static let foundEyeWidth: CGFloat = 34
    static let foundEyeHeight: CGFloat = 50

    static let notFoundEyeWidth: CGFloat = 25
    static let notFoundEyeHeight: CGFloat = 25

    static let foundEyesMargin: CGFloat = 50
    static let notFoundEyesMargin: CGFloat = 55

    static let foundEyesTopMargin: CGFloat = 120
    static let notFoundEyesTopMargin: CGFloat = 130
}
