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
            ImageLoader.fetchAndLoad(user.avatarUrl!, imageView: userImage) {
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSelectorBasedOn(indexPath)
    }
    
    let indexPathSelectors = [
        "section1row0" : "reviewOctoPodium",
        "section2row1" : "showOctoPodiumReadMe",
        "section2row2" : "followMeOnTwitter",
    ]
    
    func performSelectorBasedOn(indexPath: NSIndexPath) {
        let key = "section\(indexPath.section)row\(indexPath.row)"
        if let selector = indexPathSelectors[key] {
            performSelector(Selector(selector))
        }
    }
    
    func followMeOnTwitter() {
        let _ = Twitter.Follow(username: K.twitterHandle)
        Analytics.SendToGoogle.showOnTwitterEvent()
    }
    
    func reviewOctoPodium() {
        Analytics.SendToGoogle.reviewInAppStoreEvent()
        Browser.openPage("itms-apps://itunes.apple.com/app/id\(K.appId)")
    }
    
    func showOctoPodiumReadMe() {
        Analytics.SendToGoogle.viewOctoPodiumReadMeEvent()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if segue.identifier == kSegues.gotToTrendingDetailsFromSettingsSegue {
            let vc = segue.destinationViewController as! TrendingRepositoryDetailsController
            vc.repository = Repository(name: K.appGithubRepository, stars: "0", description: "", language: "Swift")
        }
    }
    
}