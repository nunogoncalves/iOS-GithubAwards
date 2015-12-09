//
//  UsersSearchController.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 26/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class UsersSearchController: UIViewController {

    var user: User?
    
    @IBOutlet weak var resultsScroll: UIScrollView!
    @IBOutlet weak var searchField: UISearchBar!
    var searchingLabel: UILabel!
    
    @IBAction func searchClicked() {
        if let login = searchField.text {
            if login.characters.count > 0 {
                searchUserFor(login)
            }
        }
    }
    
    var timer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchingLabel = UILabel(frame: CGRectMake(10, 20, resultsScroll.frame.width - 20, 20))
        searchingLabel.textColor = .whiteColor()
        resultsScroll.addSubview(searchingLabel)
        resultsScroll.contentSize = CGSizeMake(resultsScroll.frame.size.width, CGFloat(20));
    }

    private func restartTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "refreshSearchingLabel", userInfo: nil, repeats: true)
    }
    
    var points = 0
    
    func refreshSearchingLabel() {
        points += 1
        if points == 4 { points = 0 }
        searchingLabel.text = "Searching\(String(count: points, repeatedValue: Character(".")))"
    }

    var numberOfSubviews = 2
    private func addLabelToScroll(text: String) {
        let label = UILabel(frame: CGRectMake(10, CGFloat(20 * numberOfSubviews), resultsScroll.frame.width - 20, 20))
        label.text = text
        label.textColor = .whiteColor()
        resultsScroll.addSubview(label)
        resultsScroll.contentSize = CGSizeMake(resultsScroll.frame.size.width, CGFloat(20 * (numberOfSubviews + 1)));
        numberOfSubviews += 1
        
        if resultsScroll.contentSize.height > resultsScroll.bounds.size.height {
            let bottomOffset = CGPointMake(0, resultsScroll.contentSize.height - resultsScroll.bounds.size.height);
            resultsScroll.setContentOffset(bottomOffset, animated: true)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "UsersSearchToDetailSegue" {
            let vc = segue.destinationViewController as! UserDetailsController
            if let user = user {
                vc.user = user
            }
        }
    }
    
    private func searchUserFor(login: String) {
        showLoadingIndicatior()
        GetUser(login: login).fetch(gotUser, failure: failedToSearchForUser)
    }
    
    private func gotUser(user: User) {
        addLabelToScroll("Found user \(searchField.text!)")
        stopLoadingIndicator()
    }
    
    private func failedToSearchForUser() {
        NotifyError.display()
    }
    
    private func showLoadingIndicatior() {
        restartTimer()
    }
    
    private func stopLoadingIndicator() {
        timer?.invalidate()
        timer = nil
    }
}