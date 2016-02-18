//
//  TrendingRepositoryDetailsController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 02/02/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class TrendingRepositoryDetailsController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loadingView: GithubLoadingView!
    
    var repository: Repository?
    
    override func viewDidLoad() {
        webView.delegate = self
        navigationItem.title = repository?.name
        loadWebView()
        SendToGoogleAnalytics.enteredScreen(String(TrendingRepositoryDetailsController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "showRepoOptions")
    }
    @objc private func showRepoOptions() {        
        let repoBuilder = RepositoryOptionsBuilder.build(repository!) { [weak self] in
            guard let s = self else { return }
            let activityViewController = UIActivityViewController(activityItems: [s.repository!.url as NSString], applicationActivities: nil)
            s.presentViewController(activityViewController, animated: true, completion: {})
        }
        presentViewController(repoBuilder, animated: true, completion: nil)
    }
    
    private func loadWebView() {
        getReadMeLocation()
    }
    
    private func getReadMeLocation() {
        guard let repository = repository else { return }
        
        GitHub.RepoContentFetcher(repositoryName: repository.completeName)
            .get(success: gotGithubApiResponse, failure: gitHubApiFailed)
    }
    
    private func gotGithubApiResponse(readMeLocation: String) {
        if readMeLocation != "" {
            gotReadMeLocation(readMeLocation)
        } else {
            hideLoadingAndDisplay("Coudn't find a read me.")
        }
    }
    
    private func gitHubApiFailed(status: NetworkStatus) {
        hideLoadingAndDisplay(status.message())
    }

    private func gotReadMeLocation(url: String) {
        let url =  NSURL(string: url)
        webView.loadRequest(NSURLRequest(URL: url!))
    }
    
    private func hideLoadingAndDisplay(error: String) {
        loadingView.hide()
        NotifyError.display(error)
    }
}

extension TrendingRepositoryDetailsController : UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        animateLoadingToCorner()
    }
    
    private func animateLoadingToCorner() {
        let duration: NSTimeInterval = 1.0
        UIView.animateWithDuration(duration) {
            self.loadingView.transform = CGAffineTransformScale(self.loadingView.transform, 0.5, 0.5)
        }
        
        let path = buildCurveToCorner()
        let anim = buildAnimationIn(path, withDuration: duration)
        
        CATransaction.begin()
        loadingView.layer.addAnimation(anim, forKey: "curve")
        CATransaction.commit()
    }
    
    private func buildAnimationIn(path: UIBezierPath, withDuration duration: NSTimeInterval) -> CAKeyframeAnimation {
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.rotationMode = kCAAnimationPaced
        anim.fillMode = kCAFillModeForwards
        anim.removedOnCompletion = false
        anim.duration = duration
        anim.path = path.CGPath
        return anim
    }
    
    private func buildCurveToCorner() -> UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(view.center)
        let destinationPoint = getCornerPoint()
        path.addQuadCurveToPoint(destinationPoint, controlPoint: CGPoint(x: view.center.x, y: view.center.y + 150))
        return path
    }
    
    private func getCornerPoint() -> CGPoint {
        let p = CGPoint(
            x: view.frame.width - loadingView.halfWidth,
            y: view.frame.height - 49 - loadingView.halfHeight)
        return p
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loadingView.hide()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        hideLoadingAndDisplay("Error loading README contents")
        loadingView.hide()
    }
}


