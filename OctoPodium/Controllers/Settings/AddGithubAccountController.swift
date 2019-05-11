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
        if OnePasswordExtension.shared().isAppExtensionAvailable() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "onepassword-button"), style: .plain, target: self, action: #selector(onePasswordClicked))
        }
    }
    
    @objc private func onePasswordClicked() {
        OnePasswordExtension.shared().findLogin(
            forURLString: "http://www.github.com",
            for: self,
            sender: nil
        ) { [weak self] loginData, error in
            if let error = error {
                if error._code == Int(AppExtensionErrorCodeCancelledByUser) {
                    NotifyWarning.display("There was a problem loading 1Password credentials")
                }
            } else {
                self?.loginTextView.text = loginData![AppExtensionUsernameKey] as? String
                self?.passwordTextView.text = loginData![AppExtensionPasswordKey] as? String
            }
        }
    }
    
    @objc func loginInGithub() {
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
    
    private func userAuthenticationSuccess(_ oAuthToken: String) {
        if GithubToken.instance.saveOrUpdate(oAuthToken) {
            Analytics.SendToGoogle.loggedInWithGitHub(twoFactorAuth != nil)
            userDelegate?.readyForUser()
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    private func userAuthenticationFailed(_ apiResponse: ApiResponse) {
        if apiResponse.status == .unauthorized {
            if  apiResponse.isMissing2FactorAuthField() {
                self.showAlertFor2FactorAuthenticationCode()
            } else {
                if let message = apiResponse.json?["message"] as? String {
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
        let alertcontroller = UIAlertController(title: "Two Factor Authentication", message: "Please enter the code you received.", preferredStyle: .alert)
        
        alertcontroller.addTextField { textField in
            textField.placeholder = "2 Factor Authenticator code"
            textField.keyboardType = .numberPad
        }
        
        let ok = UIAlertAction(title: "Authenticate", style: .default) { action in
            self.twoFactorAuth = alertcontroller.textFields!.first!.text
            self.loginInGithub()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertcontroller.addAction(cancel)
        alertcontroller.addAction(ok)
        
        present(alertcontroller, animated: true, completion: {})
    }
}

extension AddGithubAccountController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
        let message = json?["message"] as? String ?? ""
        return message == "Must specify two-factor authentication OTP code."
    }
}
