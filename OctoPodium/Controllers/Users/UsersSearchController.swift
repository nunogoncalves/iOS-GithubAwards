//
//  UsersSearchController.swift
//  OctoPodium
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
    @IBOutlet weak var eyeLeft: UIImageView!
    @IBOutlet weak var eyeRight: UIImageView!
    @IBOutlet weak var xEyeLeft: UIImageView!
    @IBOutlet weak var xEyeRight: UIImageView!
    
    
    @IBOutlet weak var userContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingIndicator: GithubLoadingView!
    
    var user: User?
    
    let userMovementAnimationDuration: TimeInterval = 0.3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.searchDelegate = self
        searchField.becomeFirstResponder()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showUser))
        userSearchContainer.addGestureRecognizer(tapGesture)
        Analytics.SendToGoogle.enteredScreen(kAnalytics.userSearchScreen)
    }

    override func viewWillAppear(_ animated: Bool) {
        if let _ = User.getUserInUserDefaults() {
            let meButton = UIBarButtonItem(title: "Me", style: UIBarButtonItemStyle.plain, target: self, action: #selector(selectMe))
            navigationItem.rightBarButtonItem = meButton
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc private func selectMe() {
        if let user = User.getUserInUserDefaults() {
            searchField.text = user.login!
            searchUserFor(user.login!)
            searchField.resignFirstResponder()
        }
    }
    
    @objc private func showUser() {
        performSegue(withIdentifier: kSegues.userSearchToDetail, sender: self)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kSegues.userSearchToDetail {
            let vc = segue.destinationViewController as! UserDetailsController
            if let user = user {
                vc.userPresenter = UserPresenter(user: user)
            }
        }
    }
    
    private func searchUserFor(_ login: String) {
        userSearchContainer.hide()
        loadingIndicator.show()
        userContainerTopConstraint.constant = -80.0
        UIView.animate(withDuration: userMovementAnimationDuration) { self.view.layoutIfNeeded() }
        Users.GetOne(login: login).call(success: gotUser, failure: failedToSearchForUser)
        Analytics.SendToGoogle.userSearched(login)
    }
    
    private func gotUser(_ user: User) {
        userNotFoundLabel.hide()
        showEyeBalls()
        
        userLoginLabel.text = user.login!
        
        if let city = user.city {
            userLocationLabel.text = "\(user.country!.capitalized), \(city.capitalized)"
        } else {
            userLocationLabel.text = "\(user.country ?? "")"
        }
        let a = user.rankings.reduce(0) { (value, ranking) -> Int in
            return value + ranking.stars
        }
        
        userStarsLabel.text = "\(a ?? 0)"
        
        loadingIndicator.hide()
        userSearchContainer.show()
        self.user = user
        avatarImageView.fetchAndLoad(user.avatarUrl!)
        
        userContainerTopConstraint.constant = 6.0
        UIView.animate(withDuration: userMovementAnimationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func showEyeBalls() {
        xEyeLeft.hide()
        xEyeRight.hide()
        
        eyeLeft.show()
        eyeRight.show()
    }
    
    private func showEyeCrosses() {
        xEyeLeft.show()
        xEyeRight.show()
        
        eyeLeft.hide()
        eyeRight.hide()
    }
    
    private func failedToSearchForUser(_ apiResponse: ApiResponse) {
        loadingIndicator.hide()
        
        userNotFoundLabel.show()
        showEyeCrosses()
        
        if apiResponse.status.isTechnicalError() {
            NotifyError.display(apiResponse.status.message())
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchField.resignFirstResponder()
    }
}

extension UsersSearchController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        
        if text.characters.count > 0 {
            searchUserFor(text)
            searchBar.resignFirstResponder()
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
