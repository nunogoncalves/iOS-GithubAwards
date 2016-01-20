//
//  UserDetailsController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class UserDetailsController: UIViewController {

    @IBOutlet weak var avatarBackground: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var profileBackgroundView: UIView!
    @IBOutlet weak var countryAndCityLabel: UILabel!
    
    @IBOutlet weak var locationTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var buttonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewOnGithubButton: UIButton!
    
    @IBOutlet weak var loadingView: GithubLoadingView!
    
    @IBOutlet weak var statsContainer: UIView!
    
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
    
    var halfWidth: CGFloat!
    
    var originalAvatarTransform: CGAffineTransform!
    var originalAvatarBackgroundWidth: CGFloat!

    var originalLocationTransform: CGAffineTransform!
    var locationTransformRelation: CGFloat!
    
    let profileBackgroundHeight: CGFloat = 182
    
    let avatarTransformMin: CGFloat = 0.5
    var avatarTransformRelation: CGFloat!
    
    override func viewDidLoad() {
        if let city = user?.city {
            countryAndCityLabel.text = "\(user!.country!.capitalizedString), \(city.capitalizedString)"
        } else {
            countryAndCityLabel.text = "\(user!.country ?? "")"
        }
        countryAndCityLabel.layoutIfNeeded()
        
        calculateScrollerConstants()
        
        loadAvatar()
        applyGradient()
        navigationItem.title = user!.login
        
        rankingsTable.registerNib(UINib(nibName: String(RankingCell), bundle: nil), forCellReuseIdentifier: String(RankingCell))
        Users.GetOne(login: user!.login!).get(success: userSuccess, failure: failure)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if timer != nil {
            invalidateTimer()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let locationTransformMin = calculateLocationTransformMin()
        locationTransformRelation = (locationTransformMin - 1) / profileBackgroundHeight
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
    
    private func calculateScrollerConstants() {
        halfWidth = view.width / 2
        
        avatarTransformRelation = (avatarTransformMin - 1) / profileBackgroundHeight
        originalAvatarBackgroundWidth = avatarBackground.frame.width
        originalAvatarTransform = avatarBackground.transform
        
        originalLocationTransform = countryAndCityLabel.transform
    }
    
    private func calculateLocationTransformMin() -> CGFloat {
        if locationLabelFitsWithImageAndButton() {
            return 1.0
        }
        
        let labelWidth = countryAndCityLabel.width
        let freeSpace = view.width - (avatarTransformMin * avatarBackground.width) - viewOnGithubButton.width - 40
        
        let fitRelation = freeSpace / labelWidth
        
        return fitRelation
    }
    
    private func locationLabelFitsWithImageAndButton() -> Bool {
        let labelWidth = countryAndCityLabel.width
        let avatarSmallWidth = avatarBackground.width * avatarTransformMin
        let totalWidth = labelWidth + viewOnGithubButton.width + avatarSmallWidth
        let totalSpacingBetweenViews: CGFloat = 40
        if totalWidth + totalSpacingBetweenViews > view.width { //40 -> spacing between views
            return false
        }
        return true
    }
}

// Mark - Fetch callbacks
extension UserDetailsController {
    func userSuccess(user: User) {
        self.user = user
        applyReposStarsAndTrophiesLabelsFor(user)
        if let city = user.city {
            countryAndCityLabel.text = "\(user.country!.capitalizedString), \(city.capitalizedString)"
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
        return (isPodium(rank.worldRanking) ? 1 : 0) + (isPodium(rank.cityRanking) ? 1 : 0) + (isPodium(rank.countryRanking) ? 1 : 0)
    }
    
    private func isPodium(rank: Int?) -> Bool {
        if rank == nil { return false }
        return rank! < 4 && rank! > 0
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
        
        let y = scrollView.contentOffset.y
        
        if y < profileBackgroundHeight && y >= 0 {
            moveFor(y)
        } else {
            if y > profileBackgroundHeight {
                moveFor(CGFloat(profileBackgroundHeight))
            } else if y < 0 {
                moveFor(CGFloat(0))
            }
        }
    }
    
    private func moveFor(offset: CGFloat) {
        // Plenty of y = mx + b now.
        
        let profileBgHeight = (117 / profileBackgroundHeight) * offset + profileBackgroundHeight
        profileTopConstraint.constant = profileBackgroundHeight - profileBgHeight
        statsContainer.alpha = 1 - (offset / profileBackgroundHeight)
        
        if user!.hasLocation() { moveLocationLabel(offset) }
        moveAvatar(offset)
        moveButton(offset)
    }
    
    private func moveLocationLabel(y: CGFloat) {
        if locationTransformRelation == nil {
            locationTransformRelation = avatarTransformRelation
        }
        let transformSize = locationTransformRelation * y + 1
        countryAndCityLabel.transform = CGAffineTransformScale(originalLocationTransform, transformSize, transformSize)
        
        locationTopConstraint.constant = -(70 / profileBackgroundHeight) * y + 90
        locationCenterConstraint.constant = -((halfWidth - countryAndCityLabel.halfWidth - avatarBackground.frame.width - 20) / profileBackgroundHeight) * y
    }
    
    private func moveAvatar(y: CGFloat) {
        let transformSize = avatarTransformRelation * y + 1
        avatarBackground.transform = CGAffineTransformScale(originalAvatarTransform, transformSize, transformSize)
        
        avatarTopConstraint.constant = -(15 / profileBackgroundHeight) * y + 10
        avatarCenterXConstraint.constant = -((halfWidth - avatarBackground.halfWidth - 10) / profileBackgroundHeight) * y
    }
    
    private func moveButton(y: CGFloat) {
        buttonCenterConstraint.constant = (((halfWidth - viewOnGithubButton.halfWidth - 10) / profileBackgroundHeight) * y)
        buttonTopConstraint.constant = 118 - ((102 / profileBackgroundHeight) * y)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return user!.hasLocation() ? 158 : 78
    }
}

extension UserDetailsController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempRankings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(RankingCell), forIndexPath: indexPath) as! RankingCell
        cell.rankingPresenter = RankingPresenter(ranking: rankings[indexPath.row])
        return cell
    }
}

private extension UIView {
    var halfWidth: CGFloat { get { return width / 2 } }
    var width: CGFloat { get { return frame.width } }
    var heigth: CGFloat { get { return frame.width } }
}