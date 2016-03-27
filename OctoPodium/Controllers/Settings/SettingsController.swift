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
    
    private let followMeOnTwitterIndexPath = NSIndexPath(forRow: 2, inSection: 2)
    private let reviewOctoPodiumIndexPath = NSIndexPath(forRow: 0, inSection: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if isFollowMeOnTwitterIndexPath(indexPath: indexPath) {
            let _ = Twitter.Follow(username: K.twitterHandle)
        }
        
        if isReviewOctoPodiumIndexPath(indexPath: indexPath) {
            Browser.openPage("itms-apps://itunes.apple.com/app/id\(K.appId)")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if segue.identifier == kSegues.gotToTrendingDetailsFromSettingsSegue {
            let vc = segue.destinationViewController as! TrendingRepositoryDetailsController
            vc.repository = Repository(name: K.appGithubRepository, stars: "0", description: "", language: "Swift")
        }
    }
    
    private func isFollowMeOnTwitterIndexPath(indexPath ip: NSIndexPath) -> Bool {
        return ip == followMeOnTwitterIndexPath
    }
    
    private func isReviewOctoPodiumIndexPath(indexPath ip: NSIndexPath) -> Bool {
        return ip == reviewOctoPodiumIndexPath
    }
    
}