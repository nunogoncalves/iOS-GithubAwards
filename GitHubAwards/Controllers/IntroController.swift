//
//  IntroController.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 01/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class IntroController: UIViewController {

    @IBOutlet weak var rays: UIImageView!
    @IBOutlet weak var bigMedal: UIView!
    
    @IBOutlet weak var medalTopConstraint: NSLayoutConstraint!
    private var originalTopConstraint: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalTopConstraint = medalTopConstraint.constant

    }
    
    override func viewWillAppear(animated: Bool) {
        animateIntro()
    }
    
    private func animateIntro() {
        let duration: NSTimeInterval = 2.0
        self.medalTopConstraint.constant = 200
        UIView.animateWithDuration(duration) {
            self.view.layoutIfNeeded()
        }
        UIView.animateWithDuration(duration,
            animations: { _ in
            self.rays.rotate(1.0)
            }) { _ in
                self.performSegueWithIdentifier("GoToAppSegue", sender: nil)
        }
        
        UIView.animateWithDuration(duration) {
            
        }
    }
}

extension UIView {
    func rotate(α: CGFloat) {
        let newTransform = CGAffineTransformRotate(transform, α);
        transform = newTransform
    }
}
