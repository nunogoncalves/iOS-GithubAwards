//
//  Notification.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 29/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

class Notification : NSObject {
    
    let errorDuration: NSTimeInterval = 0.75
    let window = UIApplication.sharedApplication().keyWindow!
 
    static let instance = Notification()
    
    private override init() {}
    
    var isDisplaying = false
    
    func display(_ message: String? = nil, alertType: AlertType) {
        if isDisplaying {
            return
        }
        isDisplaying = true
        
        let alertView = AlertView(frame: CGRect(x: 0, y: -80, width: window.width, height: 84))
        alertView.setStyle(alertType)
        
        if let message = message {
            alertView.setMessage(message)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        alertView.addGestureRecognizer(tapGesture)
        
        window.addSubview(alertView)
        let windowWidth = window.frame.width
        
        UIView.animateWithDuration(0.5,
                                   delay: 0,
                                   usingSpringWithDamping: 0.4,
                                   initialSpringVelocity: 1,
                                   options: [],
                                   animations: {
                                    alertView.frame = CGRect(x: 0, y: -20, width: windowWidth, height: 84)
                                   }, completion: { _ in
                                     self.performSelector(#selector(self.dismiss(_:)), withObject: alertView, afterDelay: 1.25)
                                   }
        )
    }
    
    @objc private func onTap(_ tapGesture: UITapGestureRecognizer) {
        dismiss(tapGesture.view!)
    }
    
    func dismiss(_ view: UIView) {
        UIView.animateWithDuration(0.3, animations: {
            view.frame = CGRectOffset(view.frame, 0, -128)
            }, completion: { [weak self] _ in
                view.removeFromSuperview()
                self?.isDisplaying = false
            }
        )
    }

}
