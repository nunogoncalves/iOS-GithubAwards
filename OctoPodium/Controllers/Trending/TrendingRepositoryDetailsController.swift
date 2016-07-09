//
//  TrendingRepositoryDetailsController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 02/02/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

private enum StarState {
    
    case undefined
    case starred
    case unstarred
    
}

class TrendingRepositoryDetailsController: UIViewController {

    @IBOutlet weak var starsGithubButton: GithubStarButton!
    @IBOutlet weak var forksGithubButton: GithubForkButton!
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loadingView: GithubLoadingView!
    
    var repository: Repository?
    
    private var starState = StarState.undefined
    
    override func viewDidLoad() {
        webView.delegate = self
        navigationItem.title = repository?.name
        loadWebView()
        fetchStarsAndForks()
        checkIfIsStarted()
        Analytics.SendToGoogle.enteredScreen(String(TrendingRepositoryDetailsController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showRepoOptions))
        
        let githubButtonsFrame = CGRect(x: 0, y: 0, width: 138, height: 33)
        starsGithubButton.frame = githubButtonsFrame
        forksGithubButton.frame = githubButtonsFrame
        view.layoutIfNeeded()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(starsButtonClicked))
        starsGithubButton.addGestureRecognizer(tapGesture)
    }
    
    @objc private func showRepoOptions() {        
        let repoBuilder = RepositoryOptionsBuilder.build(repository!.url) { [weak self] in
            guard let s = self else { return }
            let activityViewController = UIActivityViewController(activityItems: [s.repository!.url as NSString], applicationActivities: nil)
            s.present(activityViewController, animated: true, completion: {})
        }
        present(repoBuilder, animated: true, completion: nil)
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
    
    private func gotStarsAndForks(_ starsAndForks: (stars: Int, forks: Int)) {
        starsGithubButton.setNumberOfStars("\(starsAndForks.stars)")
        forksGithubButton.setNumberOfForks("\(starsAndForks.forks)")
    }
    
    private func checkIfIsStarted() {
        guard let repo = repository else { return }
        if GithubToken.instance.exists() {
            GitHub.StarChecker(repoOwner: repo.user, repoName: repo.name).checkIfIsStar(success: { [weak self] hasStar in
                if hasStar {
                    self?.starsGithubButton.setTitleToUnstar()
                    self?.starState = .starred
                } else {
                    self?.starsGithubButton.setTitleToStars()
                    self?.starState = .unstarred
                }
                }) { apiResponse in
            }
        }
    }
    
    private func gotGithubApiResponse(_ readMeLocation: String) {
        if readMeLocation != "" {
            gotReadMeLocation(readMeLocation)
        } else {
            hideLoadingAndDisplay("Coudn't find a read me.")
        }
    }
    
    private func gitHubApiFailed(_ apiResponse: ApiResponse) {
        hideLoadingAndDisplay(apiResponse.status.message())
    }

    private func gotReadMeLocation(_ url: String) {
        let url =  URL(string: url)
        webView.loadRequest(URLRequest(url: url!))
    }
    
    private func hideLoadingAndDisplay(_ error: String) {
        loadingView.hide()
        NotifyError.display(error)
    }
    
    @objc private func starsButtonClicked() {
        
        switch starState {
        case .starred:
            starsGithubButton.startLoading()
            starState = .undefined
            unstarRepo()
            break
        case .unstarred:
            starsGithubButton.startLoading()
            starState = .undefined
            starRepo()
            break
        default: return
        }
        
    }
    
    private func starRepo() {
        guard let repo = repository else { return }
        GitHub.StarRepository(repoOwner: repo.user, repoName: repo.name)
            .doStar({ [weak self] in self?.starSuccess()
                }, failure: { apiResponse  in
                    NotifyError.display("It was not possible to star the repository")
                }
        )
    }
    
    private func starSuccess() {
        starState = .starred
        starsGithubButton.setTitleToUnstar()
        starsGithubButton.stopLoading()
        starsGithubButton.increaseNumber()
        Analytics.SendToGoogle.starRepoEvent(repository!.completeName)
    }

    private func unstarRepo() {
        guard let repo = repository else { return }
        GitHub.UnstarRepository(repoOwner: repo.user, repoName: repo.name)
            .doUnstar({ [weak self] in self?.unstarSuccess()
                }, failure: { apiResponse  in
                    NotifyError.display("It was not possible to star the repository")
            }
        )
    }
    
    private func unstarSuccess() {
        starState = .unstarred
        starsGithubButton.decreaseNumber()
        starsGithubButton.setTitleToStars()
        starsGithubButton.stopLoading()
        Analytics.SendToGoogle.unstarRepoEvent(repository!.completeName)
    }
}

extension TrendingRepositoryDetailsController : UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        animateLoadingToCorner()
    }
    
    private func animateLoadingToCorner() {
        let duration: TimeInterval = 1.0
        UIView.animate(withDuration: duration) {
            self.loadingView.transform = self.loadingView.transform.scaleBy(x: 0.5, y: 0.5)
        }
        
        let path = buildCurveToCorner()
        let anim = buildAnimationIn(path, withDuration: duration)
        
        CATransaction.begin()
        loadingView.layer.add(anim, forKey: "curve")
        CATransaction.commit()
    }
    
    private func buildAnimationIn(_ path: UIBezierPath, withDuration duration: TimeInterval) -> CAKeyframeAnimation {
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.rotationMode = kCAAnimationPaced
        anim.fillMode = kCAFillModeForwards
        anim.isRemovedOnCompletion = false
        anim.duration = duration
        anim.path = path.cgPath
        return anim
    }
    
    private func buildCurveToCorner() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: view.center)
        let destinationPoint = getCornerPoint()
        path.addQuadCurve(to: destinationPoint, controlPoint: CGPoint(x: view.center.x, y: view.center.y + 150))
        return path
    }
    
    private func getCornerPoint() -> CGPoint {
        let p = CGPoint(
            x: view.frame.width - loadingView.halfWidth,
            y: view.frame.height - 49 - loadingView.halfHeight)
        return p
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadingView.hide()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: NSError?) {
        hideLoadingAndDisplay("Error loading README contents")
        loadingView.hide()
    }
}


