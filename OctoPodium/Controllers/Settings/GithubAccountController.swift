//
//  GithubAccountController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 26/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

protocol Userable: class {
    func readyForUser()
}

class GithubAccountController : UIViewController {
    
    @IBOutlet weak var userContainer: UIView!
    @IBOutlet weak var userBlurView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userBackgroundImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.SendToGoogle.enteredScreen(String(GithubAccountController))
        
        if !GithubToken.instance.exists() {
            addNewAccountButton()
        } else {
            fetchUser()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        userContainer.hidden = !GithubToken.instance.exists()
    }
    
    @IBAction func signout() {
        if GithubToken.instance.deleteSessionToken() {
            Analytics.SendToGoogle.loggedOutOfGitHub()
            User.removeUserFromDefaults()
            userContainer.hide()
            addNewAccountButton()
        }
    }
    
    private func addNewAccountButton() {
        let addAccountButton = UIBarButtonItem(barButtonSystemItem: .Add,
                                               target: self,
                                               action: #selector(addGihubAccount))
        navigationItem.rightBarButtonItem = addAccountButton
    }

    private func fetchUser() {
        GitHub.UserInfoGetter().call(success: { user in
            self.gotUser(user)
            }, failure: { apiResponse in
                NotifyError.display(apiResponse.status.message())
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kSegues.goToLoginSegue {
            let vc = segue.destinationViewController as! AddGithubAccountController
            vc.userDelegate = self
        }
    }
    
    @objc private func addGihubAccount() {
        performSegueWithIdentifier(kSegues.goToLoginSegue, sender: self)
    }
    
    func gotUser(user: User) {
        userContainer.show()
        user.saveInUserDefaults()
        navigationItem.rightBarButtonItem = nil
        self.usernameLabel.text = "   \(user.login ?? "")   "
        if let avatar = user.avatarUrl {
            ImageLoader.fetchAndLoad(avatar, imageView: userImageView)
            ImageLoader.fetchAndLoad(avatar, imageView: userBackgroundImageView)

            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
            visualEffectView.frame = userBlurView.bounds
            visualEffectView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            visualEffectView.frame = CGRect(x: 0, y: 0, width: userBlurView.width, height: userBlurView.height)
            
            userBlurView.addSubview(visualEffectView)

        }
    }
    
}

extension GithubAccountController : Userable {
    
    func readyForUser() {
        fetchUser()
    }
}
