//
//  UsersSearchController.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 26/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class UsersSearchController: UIViewController {
   
    @IBOutlet weak var searchField: SearchBar!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userLoginLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var userStarsLabel: UILabel!
    @IBOutlet weak var userSearchContainer: UIView!
    
    @IBOutlet weak var userNotFoundLabel: UILabel!
    @IBOutlet weak var xEyeLeft: UIImageView!
    @IBOutlet weak var xEyeRight: UIImageView!
    
    
    @IBOutlet weak var userContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingIndicator: GithubLoadingView!
    
    var user: User?
    
    var timer: NSTimer?
    
    let userMovementAnimationDuration: NSTimeInterval = 0.3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.searchDelegate = self
        searchField.becomeFirstResponder()
        let tapGesture = UITapGestureRecognizer(target: self, action: "showUser")
        userSearchContainer.addGestureRecognizer(tapGesture)
    }

    @objc private func showUser() {
        performSegueWithIdentifier(kSegues.userSearchToDetail, sender: self)
    }
    
    private func restartTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(
            0.5,
            target: self,
            selector: "refreshSearchingLabel",
            userInfo: nil,
            repeats: true
        )
    }
    
    var points = 0
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kSegues.userSearchToDetail {
            let vc = segue.destinationViewController as! UserDetailsController
            if let user = user {
                vc.user = user
            }
        }
    }
    
    private func searchUserFor(login: String) {
        showLoadingIndicatior()
        userSearchContainer.hide()
        loadingIndicator.show()
        userContainerTopConstraint.constant = -80.0
        UIView.animateWithDuration(userMovementAnimationDuration) { self.view.layoutIfNeeded() }
        Users.GetOne(login: login).get(success: gotUser, failure: failedToSearchForUser)
    }
    
    private func gotUser(user: User) {
        
        userNotFoundLabel.hide()
        xEyeLeft.hide()
        xEyeRight.hide()
        
        userLoginLabel.text = user.login!
        
        if let city = user.city {
            userLocationLabel.text = "\(user.country!.capitalizedString), \(city.capitalizedString)"
        } else {
            userLocationLabel.text = "\(user.country ?? "")"
        }
        let a = user.rankings.reduce(0) { (value, ranking) -> Int in
            return value + (ranking.stars ?? 0)
        }
        
        userStarsLabel.text = "\(a ?? 0)"
        
        loadingIndicator.hide()
        userSearchContainer.show()
        self.user = user
        ImageLoader.fetchAndLoad(user.avatarUrl!, imageView: avatarImageView)
        stopLoadingIndicator()
        
        userContainerTopConstraint.constant = 6.0
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func failedToSearchForUser(status: NetworkStatus) {
        loadingIndicator.hide()
        
        
        userNotFoundLabel.show()
        xEyeLeft.show()
        xEyeRight.show()
        
        stopLoadingIndicator()
        if status.isTechnicalError() {
            NotifyError.display(status.message())
        }
    }
    
    private func showLoadingIndicatior() {
        restartTimer()
    }
    
    private func stopLoadingIndicator() {
        timer?.invalidate()
        timer = nil
    }
    
}

extension UsersSearchController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        
        if text.characters.count > 2 {
            searchUserFor(text)
            searchBar.resignFirstResponder()
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}