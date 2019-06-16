//
//  AlertView.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 02/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit
import Xtensions

enum AlertType {

    case error(String)
    case success(String)
    case warning(String)

    var backgroundColor: UIColor {
        switch self {
        case .error: return UIColor(hex: 0xFF0000)
        case .success: return UIColor(hex: 0x00C10C)
        case .warning: return UIColor(hex: 0xF2BF00)
        }
    }

    var message: String {
        switch self {
        case let .error(message), let .success(message), let .warning(message): return message
        }
    }
}

class AlertView: UIView {

    private let blurView = UIView.usingAutoLayout()
    private let messageLabel: UILabel = create {
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .white
        $0.textAlignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(blurView)
        addSubview(messageLabel)
        blurView.pinToBounds(of: self)
        messageLabel.constrain(referringTo: self, top: nil, leading: 8, bottom: -20, trailing: -8)

        blurView.layoutIfNeeded()
        autoresizingMask = [.flexibleHeight, .flexibleWidth]

        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light)) as UIVisualEffectView
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        visualEffectView.frame = CGRect(x: 0, y: 0, width: blurView.frame.width, height: blurView.frame.height)

        blurView.addSubview(visualEffectView)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(with type: AlertType) {
        backgroundColor = type.backgroundColor
        messageLabel.text = type.message
    }
}
