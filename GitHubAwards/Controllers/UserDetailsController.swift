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
    
    @IBOutlet weak var loadingView: GithubLoadingView!
    
    @IBOutlet weak var totalReposLabel: UILabel!
    @IBOutlet weak var totalStarsLabel: UILabel!
    @IBOutlet weak var totalLanguagesLabel: UILabel!
    @IBOutlet weak var totalTrophiesLabel: UILabel!
    
    @IBAction func viewGithubProfileClicked() {
        if let user = user {
            let url = NSURL(string: "http://github.com/\(user.login!)")
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    
    @IBOutlet weak var rankingsTable: UITableView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var rankings = [Ranking]()
    
    var timer: NSTimer!
    var tempRankings = [Ranking]()
    
    var user: User? {
        didSet {
            if let user = user {
                navigationItem.title = user.login
                GetUser(login: user.login!).fetch(userSuccess, failure: failure)
            }
        }
    }
    
    let cellInsertionInterval: NSTimeInterval = 0.2
    let cellAnimationDuration: NSTimeInterval = 0.1
    
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
        applyReposStarsAndTrophiesLabelsFor(user)
        if let city = user.city {
            countryAndCityLabel.text = "\(user.country!), \(city)"
        } else {
            countryAndCityLabel.text = "\(user.country!)"
        }
        rankings = user.rankings
        loadingView.hidden = true
        addItemsToTable()
//        rankingsTable.reloadData()
        
    }
    
    func addItemsToTable() {
        addAnotherCell()
        timer = NSTimer.scheduledTimerWithTimeInterval(cellInsertionInterval, target: self, selector: "addAnotherCell", userInfo: nil, repeats: true)
    }
 
    @objc private func addAnotherCell() {
        if tempRankings.count == rankings.count {
            timer.invalidate()
            timer = nil
            return
        }
        
        tempRankings.append(rankings[tempRankings.count])
        rankingsTable.insertRowsAtIndexPaths([NSIndexPath(forRow: (tempRankings.count - 1), inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func failure() {
        loadingView.hidden = true
        NotifyError.display()
    }
    
    private func applyReposStarsAndTrophiesLabelsFor(user: User) {
        var repos = 0
        var stars = 0
        var trophies = 0
        
        for rank in user.rankings {
            repos += rank.repositories ?? 0
            stars += rank.stars ?? 0
            trophies += calculateTrophiesOf(rank)
        }
        
        totalReposLabel.text = "\(repos)"
        totalStarsLabel.text = "\(stars)"
        totalLanguagesLabel.text = "\(user.rankings.count)"
        totalTrophiesLabel.text = "\(trophies)"
    }
    
    private func calculateTrophiesOf(rank: Ranking) -> Int {
        return (rank.worldRanking < 4 ? 1 : 0) + (rank.cityRanking < 4 ? 1 : 0) + (rank.countryRanking < 4 ? 1 : 0)
    }
    
}

extension UserDetailsController: UITableViewDelegate {
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let center = cell.center
        cell.center = CGPointMake(center.x - 50, center.y)
        
        UIView.beginAnimations("position", context: nil)
        UIView.setAnimationDuration(cellAnimationDuration)
        cell.center = center
        UIView.commitAnimations()
    }
}

extension UserDetailsController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempRankings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RankingCell", forIndexPath: indexPath) as! RankingCell
        cell.rankingPresenter = RankingPresenter(ranking: rankings[indexPath.row])
        return cell
    }
}
