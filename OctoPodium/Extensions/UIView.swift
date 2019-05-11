//
//  UIView.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 09/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

func create<T: UIView>(usingAutoLayout: Bool = true, configure: (T) -> Void) -> T {
    let object = T()
    object.translatesAutoresizingMaskIntoConstraints = !usingAutoLayout
    configure(object)
    return object
}

extension UIView {

    func show() {
        isHidden = false
    }
    
    func hide() {
        isHidden = true
    }

    var width: CGFloat { get { return frame.width } }
    var height: CGFloat { get { return frame.height } }
   
    var halfWidth: CGFloat { get { return width / 2 } }
    var halfHeight: CGFloat { get { return height / 2 } }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set(newValue) {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set(newValue) {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set(newValue) {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
    
    func removeAllSubviews() {
        for v in subviews  {
            v.removeFromSuperview()
        }
    }
    
    func applyGradient(_ colors: [UIColor]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        setNeedsLayout()
        layoutIfNeeded()
        gradient.frame = bounds
        gradient.colors = colors.map { $0.cgColor }
        layer.addSublayer(gradient)
    }
    
    func animateInPath(_ path: UIBezierPath, withDuration duration: TimeInterval, onFinished: (() -> ())? = {}) {
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.rotationMode = kCAAnimationPaced
        anim.fillMode = kCAFillModeForwards
        anim.isRemovedOnCompletion = false
        anim.duration = duration
        
        anim.path = path.cgPath
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            onFinished?()
        }
        layer.add(anim, forKey: "pathAnim")
    }
}

extension UIView {

    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }

    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }

    static func usingAutoLayout() -> Self {
        let anyUIView = self.init()
        anyUIView.translatesAutoresizingMaskIntoConstraints = false
        return anyUIView
    }

    @discardableResult
    public func usingAutoLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    func pinToBounds(
        of view: UIView,
        topConstant: CGFloat = 0,
        leadingConstant: CGFloat = 0,
        bottomConstant: CGFloat = 0,
        trailingConstant: CGFloat = 0
        ) {

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: topConstant),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstant),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomConstant),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingConstant)
            ])
    }

    func pinToBounds(of view: UIView, margins margin: CGFloat) {
        pinToBounds(
            of: view,
            topConstant: margin,
            leadingConstant: margin,
            bottomConstant: -margin,
            trailingConstant: -margin
        )
    }


    func pinTo(
        marginsGuide guide: UILayoutGuide,
        topConstant: CGFloat = 0,
        leadingConstant: CGFloat = 0,
        bottomConstant: CGFloat = 0,
        trailingConstant: CGFloat = 0
    ) {

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: guide.topAnchor, constant: topConstant),
            leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: leadingConstant),
            bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: bottomConstant),
            trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: trailingConstant)
        ])
    }

    public func constrain(
        referringTo view: UIView,
        all: CGFloat
        ) {
        constrain(referringTo: view, top: all, leading: all, bottom: -all, trailing: -all)
    }

    public func constrain(
        referringTo view: UIView,
        top: CGFloat? = 0,
        leading: CGFloat? = 0,
        bottom: CGFloat? = 0,
        trailing: CGFloat? = 0
    ) {

        var constraintsToActivate: [NSLayoutConstraint] = []

        if let topConstant = top {
            constraintsToActivate.append(
                topAnchor.constraint(equalTo: view.topAnchor, constant: topConstant)
            )
        }

        if let leadingConstant = leading {
            constraintsToActivate.append(
                leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingConstant)
            )
        }

        if let bottomConstant = bottom {
            constraintsToActivate.append(
                bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomConstant)
            )
        }

        if let trailingConstant = trailing {
            constraintsToActivate.append(
                trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailingConstant)
            )
        }

        NSLayoutConstraint.activate(constraintsToActivate)
    }

    public func constrain(
        referringTo guide: UILayoutGuide,
        top: CGFloat? = 0,
        leading: CGFloat? = 0,
        bottom: CGFloat? = 0,
        trailing: CGFloat? = 0
    ) {

        var constraintsToActivate: [NSLayoutConstraint] = []

        if let topConstant = top {
            constraintsToActivate.append(
                topAnchor.constraint(equalTo: guide.topAnchor, constant: topConstant)
            )
        }

        if let leadingConstant = leading {
            constraintsToActivate.append(
                leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: leadingConstant)
            )
        }

        if let bottomConstant = bottom {
            constraintsToActivate.append(
                bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: bottomConstant)
            )
        }

        if let trailingConstant = trailing {
            constraintsToActivate.append(
                trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: trailingConstant)
            )
        }

        NSLayoutConstraint.activate(constraintsToActivate)
    }

    @discardableResult
    func top(
        _ equality: (Int, Int) -> (Bool),
        _ other: NSLayoutYAxisAnchor,
        _ constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        return anchor(topAnchor, equality, other, constant)
    }

//    @discardableResult
//    func top(
//        _ equality: (Int, Int) -> (Bool),
//        _ view: UIView,
//        _ constant: CGFloat = 0
//    ) -> NSLayoutConstraint {
//        return anchor(topAnchor, equality, view.topAnchor, constant)
//    }

    @discardableResult
    func bottom(
        _ equality: (Int, Int) -> (Bool),
        _ other: NSLayoutYAxisAnchor,
        _ constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        return anchor(bottomAnchor, equality, other, constant)
    }

//    @discardableResult
//    func bottom(
//        _ equality: (Int, Int) -> (Bool),
//        _ view: UIView,
//        _ constant: CGFloat = 0
//    ) -> NSLayoutConstraint {
//        return anchor(bottomAnchor, equality, view.bottomAnchor, constant)
//    }

    @discardableResult
    func leading(
        _ equality: (Int, Int) -> (Bool),
        _ other: NSLayoutXAxisAnchor,
        _ constant: CGFloat = 0
        ) -> NSLayoutConstraint {
        return anchor(leadingAnchor, equality, other, constant)
    }

//    @discardableResult
//    func leading(
//        _ equality: (Int, Int) -> (Bool),
//        _ view: UIView,
//        _ constant: CGFloat = 0
//    ) -> NSLayoutConstraint {
//        return anchor(leadingAnchor, equality, view.leadingAnchor, constant)
//    }

//    @discardableResult
//    func trailing(
//        _ equality: (Int, Int) -> (Bool),
//        _ view: UIView,
//        _ constant: CGFloat = 0
//    ) -> NSLayoutConstraint {
//        return anchor(trailingAnchor, equality, view.trailingAnchor, constant)
//    }

    @discardableResult
    func trailing(
        _ equality: (Int, Int) -> (Bool),
        _ other: NSLayoutXAxisAnchor,
        _ constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        return anchor(trailingAnchor, equality, other, constant)
    }

    @discardableResult
    func centerX(
        _ equality: (Int, Int) -> (Bool),
        _ other: NSLayoutXAxisAnchor,
        _ constant: CGFloat = 0
        ) -> NSLayoutConstraint {
        return anchor(centerXAnchor, equality, other, constant)
    }

//    @discardableResult
//    func centerX(
//        _ equality: (Int, Int) -> (Bool),
//        _ view: UIView,
//        _ constant: CGFloat = 0
//    ) -> NSLayoutConstraint {
//        return anchor(centerXAnchor, equality, view.centerXAnchor, constant)
//    }

    @discardableResult
    func centerY(
        _ equality: (Int, Int) -> (Bool),
        _ other: NSLayoutYAxisAnchor,
        _ constant: CGFloat = 0
        ) -> NSLayoutConstraint {
        return anchor(centerYAnchor, equality, other, constant)
    }

//    @discardableResult
//    func centerY(
//        _ equality: (Int, Int) -> (Bool),
//        _ view: UIView,
//        _ constant: CGFloat = 0
//    ) -> NSLayoutConstraint {
//        return anchor(centerYAnchor, equality, view.centerYAnchor, constant)
//    }

    func anchor<T>(
        _ anchor: NSLayoutAnchor<T>,
        _ equality: (Int, Int) -> (Bool),
        _ anchor2: NSLayoutAnchor<T>,
        _ constant: CGFloat
    ) -> NSLayoutConstraint {

        let constraint: NSLayoutConstraint
        defer { constraint.isActive = true }

        switch (equality(1, 1), equality(2, 1), equality(1, 2)) {
        case (true, false, false):
            constraint = anchor.constraint(equalTo: anchor2, constant: constant)
        case (_, true, _):
            constraint = anchor.constraint(greaterThanOrEqualTo: anchor2, constant: constant)
        case (_, _, true):
            constraint = anchor.constraint(lessThanOrEqualTo: anchor2, constant: constant)
        default:
            constraint = anchor.constraint(equalTo: anchor2, constant: constant)
        }

        return constraint
    }

    static func set(_ dimension: NSLayoutDimension, _ constant: CGFloat) {
        dimension.constraint(equalToConstant: constant).isActive = true
    }
}
