//
//  UserDetailsDismissAnimator.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 10/06/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class UserDetailsDismissAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: NSTimeInterval = 0.5
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {

        guard let languagesC = transitionContext.languageRankingC, let userDetailsC = transitionContext.userDetailsC else {
            return
        }
        
        let containerView = transitionContext.containerView()!
        
        containerView.insertSubview(languagesC.view, belowSubview: userDetailsC.view)
        
        let cell = languagesC.selectedCell() as! CellWithAvatar
        let destinationAvatar = cell.avatar
        let destinationFrame = destinationAvatar.convertRect(destinationAvatar.frame, toView: languagesC.view)
        destinationAvatar.hide()
        
        //make a snapshot of the selected cell
        userDetailsC.view.setNeedsLayout()
        userDetailsC.view.layoutIfNeeded()
        
        let originalMovingView = userDetailsC.avatarImageView
        
        let movingImageView = userDetailsC.avatarImageView.snapshotViewAfterScreenUpdates(false)
        movingImageView.frame = originalMovingView.convertRect(originalMovingView.frame, toView: userDetailsC.view)
        movingImageView.frame = CGRectOffset(movingImageView.frame, -2, 62)
        containerView.addSubview(movingImageView)
        
        userDetailsC.avatarImageView.hide()
        let width = languagesC.view.bounds.size.width
        
        languagesC.view.transform = CGAffineTransformMakeTranslation(-width, 0.0)
        
        UIApplication.sharedApplication().windows.first!.backgroundColor = UIColor.whiteColor()
        
        let duration = transitionDuration(transitionContext)
        
        let imageScaleX = destinationAvatar.frame.width / movingImageView.frame.width
        let imageScaleY = destinationAvatar.frame.height / movingImageView.frame.height
        
        let path = UIBezierPath()
        path.moveToPoint(movingImageView.center)
        
        let destinationCenter = CGPoint(x: CGRectGetMidX(destinationFrame) - 2, y: CGRectGetMidY(destinationFrame) - 2)
        let controlPoint = CGPoint(x: movingImageView.center.x, y: movingImageView.center.y)
        path.addQuadCurveToPoint(destinationCenter, controlPoint: controlPoint)
        movingImageView.animateInPath(path, withDuration: duration)
        
        UIView.animateKeyframesWithDuration(
            duration,
            delay: 0,
            options: .CalculationModeCubic,
            animations: {
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: duration + 1.0, animations: {
                    languagesC.view.transform = CGAffineTransformIdentity
                    userDetailsC.view.transform = CGAffineTransformMakeTranslation(width, 0.0)
                    movingImageView.transform = CGAffineTransformMakeScale(imageScaleX, imageScaleY)
                })
            },
            completion: { _ in
                userDetailsC.avatarImageView.show()
                movingImageView.hide()
                destinationAvatar.show()
                languagesC.view.transform = CGAffineTransformIdentity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })

    }
}

private extension UIViewControllerContextTransitioning {
    var userDetailsC : UserDetailsController? {
        return viewControllerForKey(UITransitionContextFromViewControllerKey) as? UserDetailsController
    }
    
    var languageRankingC : LanguageRankingsController? {
        return viewControllerForKey(UITransitionContextToViewControllerKey) as? LanguageRankingsController
    }
}