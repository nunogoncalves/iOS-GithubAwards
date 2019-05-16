//
//  Notification.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 29/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

class Notification : NSObject {
    
    let errorDuration: TimeInterval = 0.75
    let window = UIApplication.shared.keyWindow!
 
    static let shared = Notification()
    
    private override init() {}
    
    var isDisplaying = false
    
    func display(_ alertType: AlertType) {
        if isDisplaying {
            return
        }
        isDisplaying = true
        
        let alertView = AlertView(frame: CGRect(x: 0, y: -80, width: window.width, height: 84))
        alertView.render(with: alertType)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        alertView.addGestureRecognizer(tapGesture)
        
        window.addSubview(alertView)
        let windowWidth = window.frame.width
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 1,
            options: [],
            animations: {
                alertView.frame = CGRect(x: 0, y: -20, width: windowWidth, height: 84)
            }, completion: { _ in
                self.perform(#selector(self.dismiss(_:)), with: alertView, afterDelay: 1.25)
            }
        )
    }
    
    @objc private func onTap(_ tapGesture: UITapGestureRecognizer) {
        dismiss(tapGesture.view!)
    }
    
    @objc func dismiss(_ view: UIView) {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                view.frame = view.frame.offsetBy(dx: 0, dy: -128)
            },
            completion: { [weak self] _ in
                view.removeFromSuperview()
                self?.isDisplaying = false
            }
        )
    }

}
