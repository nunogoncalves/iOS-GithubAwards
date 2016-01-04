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
            Browser.openPage("http://github.com/\(user.login!)")
        }
    }
    
    @IBOutlet weak var rankingsTable: UITableView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var rankings = [Ranking]()
    
    weak var timer: NSTimer!
    var tempRankings = [Ranking]()
    
    var user: User?
    
    var animateCells = true
    
    let cellInsertionInterval: NSTimeInterval = 0.2
    let cellAnimationDuration: NSTimeInterval = 0.1
    
    override func viewDidLoad() {
        loadAvatar()
        applyGradient()
        navigationItem.title = user!.login
        Users.GetOne(login: user!.login!).get(success: userSuccess, failure: failure)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if timer != nil {
            invalidateTimer()
        }
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
        gradient.colors = buidGradientOfColors()
        profileBackgroundView.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    private func buidGradientOfColors() -> [CGColor] {
        return kColors.userGradientColors.map { UIColor(rgbValue: $0).CGColor }
    }
}

// Mark - Fetch callbacks
extension UserDetailsController {
    func userSuccess(user: User) {
        self.user = user
        applyReposStarsAndTrophiesLabelsFor(user)
        if let city = user.city {
            countryAndCityLabel.text = "\(user.country!), \(city)"
        } else {
            countryAndCityLabel.text = "\(user.country ?? "")"
        }
        rankings = user.rankings
        loadingView.hidden = true
        addItemsToTable()
        rankingsTable.reloadData()
        
    }
    
    func addItemsToTable() {
        addAnotherCell()
        timer = NSTimer.scheduledTimerWithTimeInterval(cellInsertionInterval, target: self, selector: "addAnotherCell", userInfo: nil, repeats: true)
    }
 
    @objc private func addAnotherCell() {
        if tempRankings.count == rankings.count {
            invalidateTimer()
            return
        }
        
        tempRankings.append(rankings[tempRankings.count])
        rankingsTable.insertRowsAtIndexPaths([NSIndexPath(forRow: (tempRankings.count - 1), inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    private func invalidateTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    func failure(status: NetworkStatus) {
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
        if !animateCells {
            return
        }

        let center = cell.center
        cell.center = CGPointMake(center.x - (view.frame.width), center.y)
        
        UIView.beginAnimations("position", context: nil)
        UIView.setAnimationDuration(cellAnimationDuration)
        cell.center = center
        UIView.commitAnimations()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        animateCells = false
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
