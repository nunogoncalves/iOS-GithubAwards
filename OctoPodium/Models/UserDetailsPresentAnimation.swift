//
//  UserDetailsPresentAnimation.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 11/06/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class UserDetailsPresentAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    private var fromVC: LanguageRankingsController!
    private var toVC: UserDetailsController!
    private var movingImageView: UIView!
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let containerView = transitionContext.containerView
//        fromVC = transitionContext.fromC
//        toVC = transitionContext.toC
//        toVC.view.frame = toVC.view.frame.offsetBy(dx: 0, dy: 64)
//        let width = fromVC.view.bounds.size.width
//        toVC.view.transform = CGAffineTransform(translationX: width, y: 0.0)

//        let bigAvatarFrame = toVC.avatarImageView.convert(toVC.avatarImageView.bounds, to: toVC.view)
//        toVC.avatarImageView.hide()
//
//        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
//
//        movingImageView = getMovingImageView()
//        containerView.addSubview(movingImageView)
//
//        animatePathUntil(bigAvatarFrame)
//
//        UIView.animateKeyframes(
//            withDuration: duration,
//            delay: 0,
//            options: .calculationModeCubic,
//            animations: {
//                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: self.duration, animations: {
//                    self.fromVC.view.transform = CGAffineTransform(translationX: -width, y: 0.0)
//                    self.toVC.view.transform = CGAffineTransform.identity
//                    self.movingImageView.transform = self.getUserImageScale()
//                })
//            },
//            completion: { _ in
//                self.movingImageView.hide()
//                self.toVC.avatarImageView.show()
//                (self.fromVC.selectedCell() as! CellWithAvatar).avatar.show()
//                self.fromVC.view.transform = CGAffineTransform.identity
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        })
    }
//
//    private func getMovingImageView() -> UIView {
//        //make a snapshot of the selected cell
//        var movingImageView: UIView!
//        let cell = fromVC.selectedCell() as! CellWithAvatar
//        cell.avatar.hide()
//        movingImageView = cell.avatar.snapshotView(afterScreenUpdates: false)
//        movingImageView.frame = cell.avatar.convert(cell.avatar.bounds, to: fromVC.view)
//
//        movingImageView.cornerRadius = cell.avatar.cornerRadius
//
//        movingImageView.backgroundColor = UIColor(hex: 0xE0E0E0)
//        return movingImageView
//    }
//
//    private func animatePathUntil(_ destinationFrame: CGRect) {
//        let path = UIBezierPath()
//        path.move(to: movingImageView.center)
//        let controlPoint = CGPoint(x: destinationFrame.midX, y: movingImageView.center.y)
//        let cellDestinationPoint = CGPoint(x: destinationFrame.midX, y: destinationFrame.midY + 64)
//        path.addQuadCurve(to: cellDestinationPoint, controlPoint: controlPoint)
//        movingImageView.animateInPath(path, withDuration: duration)
//    }
//
//    private func getUserImageScale() -> CGAffineTransform {
//        let imageScaleX = toVC.avatarImageView.width / movingImageView.width
//        let imageScaleY = toVC.avatarImageView.height / movingImageView.height
//        return CGAffineTransform(scaleX: imageScaleX, y: imageScaleY)
//    }

}

private extension UIViewControllerContextTransitioning {
    var fromC : LanguageRankingsController {
        return viewController(forKey: UITransitionContextViewControllerKey.from) as! LanguageRankingsController
    }

    var toC : UserDetailsController {
        return viewController(forKey: UITransitionContextViewControllerKey.to) as! UserDetailsController
    }

}
