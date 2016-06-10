//
//  GithubButton.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 13/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class GithubButton : UIView, NibView {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var rightViewLeft: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var loadingView: GithubLoadingView!
    
    internal let buttonBorderColor = UIColor(hex: 0xD5D5D5).CGColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        view.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        view.frame = bounds
    }
    
    func afterCommonInit() {
        setLayoutColors()
    }
    
    private func setLayoutColors() {
        setBorder()
        applyGradient()
    }
    
    private func setBorder() {
        for v in [leftView, rightView, rightViewLeft] { v.layer.borderColor = buttonBorderColor }
    }
    
    private func applyGradient() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [
            UIColor(hex: 0xFCFCFC).CGColor,
            UIColor(hex: 0xEEEEEE).CGColor
        ]
        leftView.layer.insertSublayer(gradient, atIndex: 0)
    }

    func startLoading() {
        loadingView.show()
        loadingView.setLoading()
        valueLabel.hide()
    }
    
    func stopLoading() {
        loadingView.hide()
        loadingView.stop()
        valueLabel.show()
    }
    
    func setName(name: String) {
        nameLabel.text = name
    }

    func setValue(value: String) {
        valueLabel.text = value
        stopLoading()
    }
    
    func setImage(image: UIImage) {
        imageView.image = image
    }
    
    func increaseNumber() {
        guard let text = valueLabel.text else { return }
        if let value = Int(text) {
            valueLabel.text = "\(value + 1)"
        }
    }
    
    func decreaseNumber() {
        guard let text = valueLabel.text else { return }
        if let value = Int(text) {
            valueLabel.text = "\(value - 1)"
        }
    }
}