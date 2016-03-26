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
    
    private var twoFactorAuth: String?
    
    weak var userDelegate: Userable?
    
    @IBAction func loginInGithub() {
        let user = loginTextView.text!
        let password = passwordTextView.text!
        
        GitHub.Login(user: user, password: password, twoFactorAuth: twoFactorAuth).login(
            { oAuthToken in
                if GithubToken.instance.saveOrUpdate(oAuthToken) {
                    self.userDelegate?.readyForUser()
                    self.navigationController?.popViewControllerAnimated(true)
                }
            
            }, failure: { apiResponse in
                if apiResponse.status == .Unauthorized {
                    let message = apiResponse.responseDictionary?["message"] as? String ?? ""
                    if  message == "Must specify two-factor authentication OTP code." {
                            self.showAlertFor2FactorAuthenticationCode()
                    } else {
                        if message == "" {
                            NotifyError.display(apiResponse.status.message())
                        } else {
                            NotifyError.display(message)
                        }
                    }
                }
            }
        )
    }
    
    private func showAlertFor2FactorAuthenticationCode() {
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
