//
//  RepositoryDetailsController.swift
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

class RepositoryDetailsController: UIViewController {

    @IBOutlet weak var starsGithubButton: GithubStarButton!
    @IBOutlet weak var forksGithubButton: GithubForkButton!
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loadingView: GithubLoadingView!
    
    var repository: Repository?
    
    private var starState = StarState.undefined

    override func viewDidLoad() {
        webView.navigationDelegate = self
        navigationItem.title = repository?.name
        loadWebView()
        fetchStarsAndForks()
        checkIfIsStarted()
        Analytics.SendToGoogle.enteredScreen(String(describing: type(of: self)))
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
            let activityViewController = UIActivityViewController(
                activityItems: [s.repository!.url.absoluteString as NSString],
                applicationActivities: nil
            )
            s.present(activityViewController, animated: true, completion: {})
        }
        present(repoBuilder, animated: true, completion: nil)
    }
    
    private func loadWebView() {
        getReadMeLocation()
    }
    
    private func getReadMeLocation() {
        guard let repository = repository else { return }
        
        GitHub.RepoContentFetcher(repositoryName: repository.fullName)
            .call(success: gotGithubApiResponse, failure: gitHubApiFailed)
    }
    
    private func fetchStarsAndForks() {
        guard let repository = repository else { return }
        GitHub.StarsAndForksFetcher(repositoryName: repository.fullName).call(success: gotStarsAndForks, failure: gitHubApiFailed)
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
        let url = URL(string: url)!
        webView.load(URLRequest(url: url))
    }
    
    fileprivate func hideLoadingAndDisplay(_ error: String) {
        loadingView.hide()
        Notification.shared.display(.error(error))
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
            .doStar(
                success: { [weak self] in
                    self?.starSuccess()
                },
                failure: { apiResponse  in
                    Notification.shared.display(.error("It was not possible to star the repository"))
                }
            )
    }
    
    private func starSuccess() {
        starState = .starred
        starsGithubButton.setTitleToUnstar()
        starsGithubButton.stopLoading()
        starsGithubButton.increaseNumber()
        Analytics.SendToGoogle.starRepoEvent(repository!.fullName)
    }

    private func unstarRepo() {
        guard let repo = repository else { return }
        GitHub.UnstarRepository(repoOwner: repo.user, repoName: repo.name)
            .doUnstar(
                success: { [weak self] in
                    self?.unstarSuccess()
                },
                failure: { apiResponse  in
                    Notification.shared.display(.error("It was not possible to star the repository"))
                }
            )
    }
    
    private func unstarSuccess() {
        starState = .unstarred
        starsGithubButton.decreaseNumber()
        starsGithubButton.setTitleToStars()
        starsGithubButton.stopLoading()
        Analytics.SendToGoogle.unstarRepoEvent(repository!.fullName)
    }
}

extension RepositoryDetailsController : WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        animateLoadingToCorner()
    }
    
    private func animateLoadingToCorner() {
        let duration: TimeInterval = 1.0
        UIView.animate(withDuration: duration) {
            self.loadingView.transform = self.loadingView.transform.scaledBy(x: 0.5, y: 0.5)
        }
        
        let animation = self.animation(in: curveToLowerRightCorner, withDuration: duration)
        
        CATransaction.begin()
        loadingView.layer.add(animation, forKey: "curve")
        CATransaction.commit()
    }
    
    private func animation(in path: UIBezierPath, withDuration duration: TimeInterval) -> CAKeyframeAnimation {
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.rotationMode = .none
        anim.calculationMode = .paced
        anim.fillMode = .forwards
        anim.isRemovedOnCompletion = false
        anim.duration = duration
        anim.path = path.cgPath
        return anim
    }
    
    private var curveToLowerRightCorner: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: view.center)
        let destinationPoint = lowerRightCornerPoint
        path.addQuadCurve(to: destinationPoint, controlPoint: CGPoint(x: view.center.x, y: view.center.y + 150))
        return path
    }
    
    private var lowerRightCornerPoint: CGPoint {
        return CGPoint(
            x: view.frame.width - loadingView.halfWidth,
            y: view.frame.height - 49 - loadingView.halfHeight
        )
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingView.hide()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoadingAndDisplay("Error loading README contents")
        loadingView.hide()
    }
}

