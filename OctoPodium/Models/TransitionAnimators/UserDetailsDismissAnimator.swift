//
//  UserDetailsDismissAnimator.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 10/06/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class UserDetailsDismissAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let languagesC = transitionContext.languageRankingC, let userDetailsC = transitionContext.userDetailsC else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        containerView.insertSubview(languagesC.view, belowSubview: userDetailsC.view)
        
        let cell = languagesC.selectedCell() as! CellWithAvatar
        let destinationAvatar = cell.avatar
        let destinationFrame = destinationAvatar?.convert((destinationAvatar?.frame)!, to: languagesC.view)
        destinationAvatar?.hide()
        
        //make a snapshot of the selected cell
        userDetailsC.view.setNeedsLayout()
        userDetailsC.view.layoutIfNeeded()
        
        let originalMovingView = userDetailsC.avatarImageView
        
        let movingImageView = userDetailsC.avatarImageView.snapshotView(afterScreenUpdates: false)
        movingImageView?.frame = (originalMovingView?.convert((originalMovingView?.frame)!, to: userDetailsC.view))!
        movingImageView?.frame = ((movingImageView?.frame)?.offsetBy(dx: -2, dy: 62))!
        containerView.addSubview(movingImageView!)
        
        userDetailsC.avatarImageView.hide()
        let width = languagesC.view.bounds.size.width
        
        languagesC.view.transform = CGAffineTransform(translationX: -width, y: 0.0)
        
        UIApplication.shared.windows.first!.backgroundColor = UIColor.white
        
        let duration = transitionDuration(using: transitionContext)
        
        let imageScaleX = destinationAvatar!.frame.width / movingImageView!.frame.width
        let imageScaleY = destinationAvatar!.frame.height / movingImageView!.frame.height
        
        let path = UIBezierPath()
        path.move(to: (movingImageView?.center)!)
        
        let destinationCenter = CGPoint(x: destinationFrame!.midX - 2, y: destinationFrame!.midY - 2)
        let controlPoint = CGPoint(x: (movingImageView?.center.x)!, y: (movingImageView?.center.y)!)
        path.addQuadCurve(to: destinationCenter, controlPoint: controlPoint)
        movingImageView?.animateInPath(path, withDuration: duration)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: duration + 1.0, animations: {
                    languagesC.view.transform = CGAffineTransform.identity
                    userDetailsC.view.transform = CGAffineTransform(translationX: width, y: 0.0)
                    movingImageView?.transform = CGAffineTransform(scaleX: imageScaleX, y: imageScaleY)
                })
            },
            completion: { _ in
                userDetailsC.avatarImageView.show()
                movingImageView?.hide()
                destinationAvatar?.show()
                languagesC.view.transform = CGAffineTransform.identity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })

    }
}

private extension UIViewControllerContextTransitioning {
    var userDetailsC : UserDetailsController? {
        return viewController(forKey: UITransitionContextViewControllerKey.from) as? UserDetailsController
    }
    
    var languageRankingC : LanguageRankingsController? {
        return viewController(forKey: UITransitionContextViewControllerKey.to) as? LanguageRankingsController
    }
}
