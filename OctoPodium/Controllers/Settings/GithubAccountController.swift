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
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var userContainer: UIView!
    @IBOutlet weak var usernameLabelContainer: UIView!
    @IBOutlet weak var userBlurView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userBackgroundImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.SendToGoogle.enteredScreen(String(describing: type(of: GithubAccountController.self)))
        applyGradient()
        if !GithubToken.instance.exists() {
            addNewAccountButton()
        } else {
            if let user = User.inUserDefaults {
                gotUser(user)
            } else {
                fetchUser()
            }
        }
    }
    
    private func applyGradient() {
        gradientView.applyGradient([
            UIColor(hex: kColors.navigationBarColor),
            UIColor(hex: kColors.tabBarColor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userContainer.isHidden = !GithubToken.instance.exists()
    }
    
    @IBAction func signout() {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _  in self.confirmLogout() } ))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: {})
    }

    @objc private func confirmLogout() {
        if GithubToken.instance.deleteSessionToken() {
            Analytics.SendToGoogle.loggedOutOfGitHub()
            User.removeUserFromDefaults()
            userContainer.hide()
            usernameLabelContainer.hide()
            userBlurView.removeAllSubviews()
            userBackgroundImageView.image = nil
            addNewAccountButton()
        }
    }
    
    private func addNewAccountButton() {
        let addAccountButton = UIBarButtonItem(barButtonSystemItem: .add,
                                               target: self,
                                               action: #selector(addGihubAccount))
        navigationItem.rightBarButtonItem = addAccountButton
    }
    
    @objc private func addRemoveAccountButton() {
        let addAccountButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                               target: self,
                                               action: #selector(signout))
        navigationItem.rightBarButtonItem = addAccountButton
    }

    fileprivate func fetchUser() {
        GitHub.UserInfoGetter().call(success: { user in
            self.gotUser(user)
            }, failure: { apiResponse in
                NotifyError.display(apiResponse.status.message())
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kSegues.goToLoginSegue {
            let vc = segue.destination as! AddGithubAccountController
            vc.userDelegate = self
        }
    }
    
    @objc private func addGihubAccount() {
        performSegue(withIdentifier: kSegues.goToLoginSegue, sender: self)
    }
    
    func gotUser(_ user: User) {
        userContainer.show()
        user.saveInUserDefaults()
        usernameLabelContainer.show()
        addRemoveAccountButton()
        usernameLabel.show()
        usernameLabel.text = "   \(user.login)   "

        let avatar = user.avatarUrl
        userImageView.fetchAndLoad(avatar)
        userBackgroundImageView.fetchAndLoad(avatar)

        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark)) as UIVisualEffectView
        visualEffectView.frame = userBlurView.bounds
        visualEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        visualEffectView.frame = CGRect(x: 0, y: 0, width: userBlurView.width, height: userBlurView.height)

        userBlurView.addSubview(visualEffectView)
    }
    
}

extension GithubAccountController : Userable {
    
    func readyForUser() {
        fetchUser()
    }
}
