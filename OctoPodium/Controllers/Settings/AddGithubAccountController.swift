//
//  AddGithubAccountController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 26/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class AddGithubAccountController : UIViewController {
    
    @IBOutlet weak var loginTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    
    @IBOutlet weak var onePasswordButton: UIButton!
    
    private var twoFactorAuth: String?
    
    weak var userDelegate: Userable?
    
    override func viewDidLoad() {
        if OnePasswordExtension.sharedExtension().isAppExtensionAvailable() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "onepassword-button"), style: .Plain, target: self, action: #selector(onePasswordClicked))
        }
    }
    
    @objc private func onePasswordClicked() {
        OnePasswordExtension.sharedExtension().findLoginForURLString(
            "http://www.github.com",
            forViewController: self,
            sender: self) { [weak self] loginData, error in
            if let error = error {
                if error.code == Int(AppExtensionErrorCodeCancelledByUser) {
                    NotifyWarning.display("There was a problem loading 1Password credentials")
                }
            } else {
                self?.loginTextView.text = loginData![AppExtensionUsernameKey] as? String
                self?.passwordTextView.text = loginData![AppExtensionPasswordKey] as? String
            }
        }
    }
    
    func loginInGithub() {
        let user = loginTextView.text!
        let password = passwordTextView.text!
        
        GitHub.Login(user: user, password: password, twoFactorAuth: twoFactorAuth).login(
            { [weak self] oAuthToken in
                self?.userAuthenticationSuccess(oAuthToken)
            }, failure: { [weak self] apiResponse in
                self?.userAuthenticationFailed(apiResponse)
            }
        )
        
    }
    
    private func userAuthenticationSuccess(oAuthToken: String) {
        if GithubToken.instance.saveOrUpdate(oAuthToken) {
            Analytics.SendToGoogle.loggedInWithGitHub(self.twoFactorAuth != nil)
            self.userDelegate?.readyForUser()
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    private func userAuthenticationFailed(apiResponse: ApiResponse) {
        if apiResponse.status == .Unauthorized {
            if  apiResponse.isMissing2FactorAuthField() {
                self.showAlertFor2FactorAuthenticationCode()
            } else {
                if let message = apiResponse.responseDictionary?["message"] as? String {
                    NotifyError.display(message)
                } else {
                    NotifyError.display(apiResponse.status.message())
                }
            }
        } else {
            NotifyError.display(apiResponse.status.message())
        }
    }
    
    private func showAlertFor2FactorAuthenticationCode() {
        Analytics.SendToGoogle.twoFactorAuthAlertShowedEvent()
        let alertcontroller = UIAlertController(title: "Two Factor Authentication", message: "Please enter the code you received.", preferredStyle: .Alert)
        
        alertcontroller.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "2 Factor Authenticator code"
            textField.keyboardType = .NumberPad
        }
        
        let ok = UIAlertAction(title: "Authenticate", style: .Default) { action in
            self.twoFactorAuth = alertcontroller.textFields!.first!.text
            self.loginInGithub()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertcontroller.addAction(cancel)
        alertcontroller.addAction(ok)
        
        presentViewController(alertcontroller, animated: true, completion: {})
    }
}

extension AddGithubAccountController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == passwordTextView {
            textField.resignFirstResponder()
            loginInGithub()
        } else if textField == loginTextView {
            passwordTextView.becomeFirstResponder()
        }
        return true
    }
}

private extension ApiResponse {
    func isMissing2FactorAuthField() -> Bool {
        let message = responseDictionary?["message"] as? String ?? ""
        return message == "Must specify two-factor authentication OTP code."
    }
}
