//
//  UserDetailsController.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class UserDetailsController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var profileBackgroundView: UIView!
    @IBOutlet weak var countryAndCityLabel: UILabel!
    
    @IBAction func viewGithubProfileClicked() {
        if let user = user {
            let url = NSURL(string: "http://github.com/\(user.login!)")
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    
    @IBOutlet weak var rankingsTable: UITableView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var rankings = [Ranking]()
    
    var user: User? {
        didSet {
            if let user = user {
                navigationItem.title = user.login
                GetUser(login: user.login!).fetch(userSuccess, failure: failure)
            }
        }
    }
    
    override func viewDidLoad() {
        loadAvatar()
        applyGradient()
    }
    
    private func loadAvatar() {
        if let avatarUrl = user!.avatarUrl {
            ImageLoader.fetchAndLoad(avatarUrl, imageView: avatarImageView) {
                self.loading.stopAnimating()
            }
        }
    }
    
    private func applyGradient() {
        view.layoutIfNeeded()
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = profileBackgroundView.bounds
        gradient.colors = [UIColor(rgbValue: 0x7354D7).CGColor, UIColor(rgbValue: K.firstInRankingColor).CGColor]
        profileBackgroundView.layer.insertSublayer(gradient, atIndex: 0)
    }
}

// Mark - Fetch callbacks
extension UserDetailsController {
    func userSuccess(user: User) {
        if let city = user.city {
            countryAndCityLabel.text = "\(user.country!), \(city)"
        } else {
            countryAndCityLabel.text = "\(user.country!)"
        }
        rankings = user.rankings
        rankingsTable.reloadData()
    }
    
    func failure() {
        NotifyError.display()
    }
}

extension UserDetailsController: UITableViewDelegate {
    
}

extension UserDetailsController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RankingCell", forIndexPath: indexPath) as! RankingCell
        cell.ranking = rankings[indexPath.row]
        return cell
    }
}
