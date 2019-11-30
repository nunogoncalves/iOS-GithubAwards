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
    
    @IBOutlet weak var animationsSwitch: UISwitch!

    weak var coordinator: SettingsCoordinator?
    
    @IBAction func animationsSwitchToggled(_ animationsSwitch: UISwitch) {
        if animationsSwitch.isOn {
            Analytics.SendToGoogle.enabledAnimations()
            CurrentUser.enableAnimations()
        } else {
            Analytics.SendToGoogle.disabledAnimations()
            CurrentUser.disableAnimations()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Analytics.SendToGoogle.enteredScreen(String(describing: SettingsController.self))
        versionLabel.text = "\(K.appVersion)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = User.inUserDefaults {
            userLabel.text = user.login
            userImage.cornerRadius = 22
            userImage.fetchAndLoad(user.avatarUrl) {
                self.tableView.reloadData()
            }
        } else {
            userImage.image = UIImage(named: "GitHub")
            userImage.cornerRadius = 0
            userLabel.text = ""
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 4 {
            tableView.deselectRow(at: indexPath, animated: false)
            return nil
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSelector(basedOn: indexPath)
    }
    
    let indexPathSelectors = [
        "section1row1" : #selector(showOctoPodiumReadMe),
        "section1row2" : #selector(starOctoPodium),
        "section1row3" : #selector(reviewOctoPodium),
        
        "section2row0" : #selector(developerTwitter),
        "section2row1" : #selector(developerGithub),
    ]
    
    func performSelector(basedOn indexPath: IndexPath) {
        let key = "section\(indexPath.section)row\(indexPath.row)"
        if let selector = indexPathSelectors[key] {
            perform(selector)
        }
    }
    
    @objc func developerTwitter() {
        let _ = Twitter.Follow(username: K.twitterHandle)
    }
    
    @objc func developerGithub() {
        Browser.openPage(K.appOwnerGithub)
        Analytics.SendToGoogle.showDeveloperOnGithubEvent()
    }
    
    @objc func reviewOctoPodium() {
        Analytics.SendToGoogle.reviewInAppStoreEvent()
        Browser.openPage(URL(string: "itms-apps://itunes.apple.com/app/id\(K.appId)")!)
    }
    
    @objc func showOctoPodiumReadMe() {
        Analytics.SendToGoogle.viewOctoPodiumReadMeEvent()
        let repository = GitAwardsRepository(
            name: "\(K.appOwnerName)/\(K.appRepositoryName)",
            stars: "0",
            description: "",
            language: "Swift"
        )
        coordinator?.showDetails(of: repository)
    }

    @objc func starOctoPodium() {
        Analytics.SendToGoogle.starOctopodiumEvent()
        GitHub.StarRepository(repoOwner: K.appOwnerName, repoName: K.appRepositoryName)
            .doStar(success: starSuccessfull, failure: starFailed)
    }

    private func starSuccessfull() {
        Notification.shared.display(.success("OctoPodium starred successfully"))
    }

    private func starFailed(_ apiResponse: ApiResponse) {
        Notification.shared.display(.error(apiResponse.status.message()))
    }
}
