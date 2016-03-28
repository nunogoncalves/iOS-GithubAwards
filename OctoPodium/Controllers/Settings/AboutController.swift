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
        SendToGoogleAnalytics.enteredScreen(String(AboutController))
        setAppNameAndYear()
        setAboutText()
    }
    
    private func setAppNameAndYear() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy"
        appInfoAndYearLabel.text = "\(K.appName) @ \(formatter.stringFromDate(NSDate()))"
    }
    
    private func setAboutText() {
        aboutTextView.text = "Hi! Thank you for using \(K.appName). \n\(K.appName) is an open source application developped on my free time. It looks so nice thanks to the help of my coleague Cláudia Conceção. It is built using Swift 2.2. \nYou can check the source code at \(K.sourceCode)"
        
    }
}
