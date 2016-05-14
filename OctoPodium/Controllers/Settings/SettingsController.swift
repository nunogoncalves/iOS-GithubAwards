//
//  SettingsController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 27/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class SettingsController : UITableViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.SendToGoogle.enteredScreen(String(SettingsController))
        versionLabel.text = "\(K.appVersion)"

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let user = User.getUserInUserDefaults() {
            userLabel.text = user.login!
            userImage.fetchAndLoad(user.avatarUrl!) {
                self.tableView.reloadData()
            }
        } else {
            userImage.image = UIImage(named: "GitHub")
            userLabel.text = ""
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 && indexPath.row == 4 {
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
            return nil
        }
        return indexPath
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSelectorBasedOn(indexPath)
    }
    
    let indexPathSelectors = [
        "section1row1" : "showOctoPodiumReadMe",
        "section1row2" : "starOctoPodium",
        "section1row3" : "reviewOctoPodium",
        
        "section2row0" : "developerTwitter",
        "section2row1" : "developerGithub",
    ]
    
    func performSelectorBasedOn(indexPath: NSIndexPath) {
        let key = "section\(indexPath.section)row\(indexPath.row)"
        if let selector = indexPathSelectors[key] {
            performSelector(Selector(selector))
        }
    }
    
    func developerTwitter() {
        let _ = Twitter.Follow(username: K.twitterHandle)
        Analytics.SendToGoogle.showDeveloperOnTwitterEvent()
    }
    
    func developerGithub() {
        Browser.openPage(K.appOwnerGithub)
        Analytics.SendToGoogle.showDeveloperOnGithubEvent()
    }
    
    func reviewOctoPodium() {
        Analytics.SendToGoogle.reviewInAppStoreEvent()
        Browser.openPage("itms-apps://itunes.apple.com/app/id\(K.appId)")
    }
    
    func showOctoPodiumReadMe() {
        Analytics.SendToGoogle.viewOctoPodiumReadMeEvent()
    }
    
    func starOctoPodium() {
        Analytics.SendToGoogle.viewOctoPodiumReadMeEvent()
        GitHub.StarRepository(repoOwner: K.appOwnerName, repoName: K.appRepositoryName)
              .doStar(starSuccessfull, failure: starFailed)
    }
    
    private func starSuccessfull() {
        NotifySuccess.display("OctoPodium starred successfully")
    }
    
    private func starFailed(apiResponse: ApiResponse) {
        NotifyError.display(apiResponse.status.message())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if segue.identifier == kSegues.gotToTrendingDetailsFromSettingsSegue {
            let vc = segue.destinationViewController as! TrendingRepositoryDetailsController
            vc.repository = Repository(name: "\(K.appOwnerName)/\(K.appRepositoryName)", stars: "0", description: "", language: "Swift")
        }
    }
    
}