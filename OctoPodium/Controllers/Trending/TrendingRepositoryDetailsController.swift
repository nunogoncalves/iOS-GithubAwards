//
//  TrendingRepositoryDetailsController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 02/02/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

private enum StarState {
    
    case Undefined
    case Starred
    case Unstarred
    
}

class TrendingRepositoryDetailsController: UIViewController {

    @IBOutlet weak var starsGithubButton: GithubStarButton!
    @IBOutlet weak var forksGithubButton: GithubForkButton!
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loadingView: GithubLoadingView!
    
    var repository: Repository?
    
    private var starState = StarState.Undefined
    
    deinit {
        
    }
    
    override func viewDidLoad() {
        webView.delegate = self
        navigationItem.title = repository?.name
        loadWebView()
        fetchStarsAndForks()
        checkIfIsStarted()
        Analytics.SendToGoogle.enteredScreen(String(TrendingRepositoryDetailsController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "showRepoOptions")
        
        let githubButtonsFrame = CGRect(x: 0, y: 0, width: 138, height: 33)
        starsGithubButton.frame = githubButtonsFrame
        forksGithubButton.frame = githubButtonsFrame
        view.layoutIfNeeded()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "starsButtonClicked")
        starsGithubButton.addGestureRecognizer(tapGesture)
    }
    
    @objc private func showRepoOptions() {        
        let repoBuilder = RepositoryOptionsBuilder.build(repository!.url) { [weak self] in
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
            .call(success: gotGithubApiResponse, failure: gitHubApiFailed)
    }
    
    private func fetchStarsAndForks() {
        guard let repository = repository else { return }
        GitHub.StarsAndForksFetcher(repositoryName: repository.completeName).call(success: gotStarsAndForks, failure: gitHubApiFailed)
    }
    
    private func gotStarsAndForks(starsAndForks: (stars: Int, forks: Int)) {
        starsGithubButton.setNumberOfStars("\(starsAndForks.stars)")
        forksGithubButton.setNumberOfForks("\(starsAndForks.forks)")
    }
    
    private func checkIfIsStarted() {
        guard let repo = repository else { return }
        if GithubToken.instance.exists() {
            GitHub.StarChecker(repoOwner: repo.user, repoName: repo.name).checkIfIsStar(success: { [weak self] hasStar in
                if hasStar {
                    self?.starsGithubButton.setTitleToUnstar()
                    self?.starState = .Starred
                } else {
                    self?.starsGithubButton.setTitleToStars()
                    self?.starState = .Unstarred
                }
                }) { apiResponse in
                    
            }
        }
    }
    
    private func gotGithubApiResponse(readMeLocation: String) {
        if readMeLocation != "" {
            gotReadMeLocation(readMeLocation)
        } else {
            hideLoadingAndDisplay("Coudn't find a read me.")
        }
    }
    
    private func gitHubApiFailed(apiResponse: ApiResponse) {
        hideLoadingAndDisplay(apiResponse.status.message())
    }

    private func gotReadMeLocation(url: String) {
        let url =  NSURL(string: url)
        webView.loadRequest(NSURLRequest(URL: url!))
    }
    
    private func hideLoadingAndDisplay(error: String) {
        loadingView.hide()
        NotifyError.display(error)
    }
    
    @objc private func starsButtonClicked() {
        
        switch starState {
        case .Starred:
            starsGithubButton.startLoading()
            starState = .Undefined
            unstarRepo()
            break
        case .Unstarred:
            starsGithubButton.startLoading()
            starState = .Undefined
            starRepo()
            break
        default: return
        }
        
    }
    
    private func starRepo() {
        guard let repo = repository else { return }
        GitHub.StarRepository(repoOwner: repo.user, repoName: repo.name)
            .doStar({ [weak self] in
                self?.starState = .Starred
                self?.starsGithubButton.setTitleToUnstar()
                self?.starsGithubButton.stopLoading()
                self?.starsGithubButton.increaseNumber()
                }, failure: { apiResponse  in
                    print(apiResponse)
                }
        )
    }

    private func unstarRepo() {
        guard let repo = repository else { return }
        GitHub.UnstarRepository(repoOwner: repo.user, repoName: repo.name)
            .doUnstar({ [weak self] in
                self?.starState = .Unstarred
                self?.starsGithubButton.decreaseNumber()
                self?.starsGithubButton.setTitleToStars()
                self?.starsGithubButton.stopLoading()
                }, failure: { apiResponse  in
                    print(apiResponse)
            }
        )
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


