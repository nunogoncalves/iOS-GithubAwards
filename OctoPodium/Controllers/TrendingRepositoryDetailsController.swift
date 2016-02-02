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
    }
    
    private func loadWebView() {
        getReadMeLocation()
    }
    
    private func getReadMeLocation() {
        guard let repository = repository else { return }
        let responseHandler = Data.ResponseHandler()
        responseHandler.successCallback = gotGithubApiResponse
        responseHandler.failureCallback = gitHubApiFailed
        
        let url = "https://api.github.com/repos/\(repository.completeName)/contents"
        Network.Requester(networkResponseHandler: responseHandler).makeGet(url)
    }
    
    private func gotGithubApiResponse(dictionary: NSDictionary) {
        for item in dictionary["response"] as! NSArray {
            let name = (item["name"] as? String) ?? ""
            if name.containsString("README") {
                if let url = item["html_url"] as? String {
                    gotReadMeLocation(url)
                }
            }
        }
        
    }
    
    private func gitHubApiFailed(status: NetworkStatus) {
        NotifyError.display(status.message())
    }

    private func gotReadMeLocation(url: String) {
        let url =  NSURL(string: url)
        webView.loadRequest(NSURLRequest(URL: url!))
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
        loadingView.hide()
        NotifyError.display("Error loading README contents")
    }
}


