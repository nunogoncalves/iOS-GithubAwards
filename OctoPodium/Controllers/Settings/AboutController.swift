//
//  AboutController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 27/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class AboutController : UIViewController {
    
    @IBOutlet weak var appInfoAndYearLabel: UILabel!
    @IBOutlet weak var aboutTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.SendToGoogle.enteredScreen(String(AboutController))
        setAppNameAndYear()
        setAboutText()
        automaticallyAdjustsScrollViewInsets = false
    }
    
    private func setAppNameAndYear() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy"
        appInfoAndYearLabel.text = "\(K.appName) @ \(formatter.stringFromDate(NSDate()))"
    }
    
    private func setAboutText() {
        aboutTextView.text = "Hi! Thank you for using \(K.appName). Hope you are enjoying using it as much as I enjoy working on it. \n\(K.appName) is an open source application developped on my free time. It looks this nice thanks to my coleague Cláudia Conceição (portfolio: http://cconceicao.com/, twitter: https://twitter.com/claudiaconceic). It is built using Swift 2.2. \nYou can check the source code at \(K.appGithubRepository)\n\nYou can read the story behind this app here: https://medium.com/@nunogonalves/my-first-app-store-app-story-6c29e01e0306\n\n A shout to Vincent Daubry (https://twitter.com/vdaubry) for his work on http://github-awards.com which allowed me to add the API to his web app."
    }
}
