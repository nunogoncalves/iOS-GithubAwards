//
//  UserDetailsPresentAnimation.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 11/06/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class UserDetailsPresentAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: NSTimeInterval = 0.5
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    private var fromVC: LanguageRankingsController!
    private var toVC: UserDetailsController!
    private var movingImageView: UIView!
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()!
        fromVC = transitionContext.fromC
        toVC = transitionContext.toC
        toVC.view.frame = CGRectOffset(toVC.view.frame, 0, 64)
        let width = fromVC.view.bounds.size.width
        toVC.view.transform = CGAffineTransformMakeTranslation(width, 0.0)

        let bigAvatarFrame = toVC.avatarImageView.convertRect(toVC.avatarImageView.bounds, toView: toVC.view)
        toVC.avatarImageView.hide()
        
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        movingImageView = getMovingImageView()
        containerView.addSubview(movingImageView)
        
        animatePathUntil(bigAvatarFrame)
        
        UIView.animateKeyframesWithDuration(
            duration,
            delay: 0,
            options: .CalculationModeCubic,
            animations: {
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: self.duration, animations: {
                    self.fromVC.view.transform = CGAffineTransformMakeTranslation(-width, 0.0)
                    self.toVC.view.transform = CGAffineTransformIdentity
                    self.movingImageView.transform = self.getUserImageScale()
                })
            },
            completion: { _ in
                self.movingImageView.hide()
                self.toVC.avatarImageView.show()
                self.fromVC.view.transform = CGAffineTransformIdentity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
    
    private func getMovingImageView() -> UIView {
        //make a snapshot of the selected cell
        var movingImageView: UIView!
        let cell = fromVC.selectedCell() as! CellWithAvatar
        cell.avatar.hide()
        movingImageView = cell.avatar.snapshotViewAfterScreenUpdates(false)
        movingImageView.frame = cell.avatar.convertRect(cell.avatar.bounds, toView: fromVC.view)
        
        movingImageView.cornerRadius = cell.avatar.cornerRadius
        
        movingImageView.backgroundColor = UIColor(hex: 0xE0E0E0)
        return movingImageView
    }
    
    private func animatePathUntil(destinationFrame: CGRect) {
        let path = UIBezierPath()
        path.moveToPoint(movingImageView.center)
        let controlPoint = CGPoint(x: CGRectGetMidX(destinationFrame), y: movingImageView.center.y)
        let cellDestinationPoint = CGPoint(x: CGRectGetMidX(destinationFrame), y: CGRectGetMidY(destinationFrame) + 64)
        path.addQuadCurveToPoint(cellDestinationPoint, controlPoint: controlPoint)
        movingImageView.animateInPath(path, withDuration: duration)
    }
    
    private func getUserImageScale() -> CGAffineTransform {
        let imageScaleX = toVC.avatarImageView.width / movingImageView.width
        let imageScaleY = toVC.avatarImageView.height / movingImageView.height
        return CGAffineTransformMakeScale(imageScaleX, imageScaleY)
    }
    
}

private extension UIViewControllerContextTransitioning {
    var fromC : LanguageRankingsController {
        return viewControllerForKey(UITransitionContextFromViewControllerKey) as! LanguageRankingsController
    }

    var toC : UserDetailsController {
        return viewControllerForKey(UITransitionContextToViewControllerKey) as! UserDetailsController
    }

}