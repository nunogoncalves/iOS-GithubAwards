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
    
    @IBOutlet weak var twitterButton: UIBarButtonItem!
    
    
    @IBAction func tweetButtonTapped(sender: UIBarButtonItem) {
        guard let userPresenter = userPresenter else { return }
        guard rankings.count > 0 else { return }
        
        _ = Twitter.Share(ranking: "\(userPresenter.ranking)",
                      language: rankings[0].language!,
                      location: userPresenter.cityOrCountryOrWorld)
    }
    @IBAction func viewGithubProfileClicked() {
        if let login = userPresenter?.login() {
            Browser.openPage("http://github.com/\(login)")
            Analytics.SendToGoogle.viewUserOnGithub(login)
        }
    }
    
    @IBOutlet weak var rankingsTable: UITableView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var rankings = [Ranking]()
    
    weak var timer: NSTimer!
    private var tempRankings = [Ranking]()
    
//    var user: User?
    var userPresenter: UserPresenter?
    
    private var animateCells = true
    
    private let cellInsertionInterval: NSTimeInterval = 0.2
    private let cellAnimationDuration: NSTimeInterval = 0.1
    
    private var halfWidth: CGFloat!
    
    private var originalAvatarTransform: CGAffineTransform!
    private var originalAvatarBackgroundWidth: CGFloat!

    private var originalLocationTransform: CGAffineTransform!
    private var locationTransformRelation: CGFloat!
    
    private let profileExtendedBGHeight: CGFloat = 182
    private let profileMinBGHeight: CGFloat = 117
    
    private let avatarTransformMin: CGFloat = 0.5
    private var avatarTransformRelation: CGFloat!
    
    override func viewDidLoad() {
        Analytics.SendToGoogle.enteredScreen(kAnalytics.userDetailsScreenFor(userPresenter!.user))
        
        if !(userPresenter?.user.isSelf() ?? false) {
            navigationItem.rightBarButtonItems = [navigationItem.rightBarButtonItems![0]]
            twitterButton = nil
        }
        
        countryAndCityLabel.text = userPresenter!.fullLocation
        countryAndCityLabel.layoutIfNeeded()
        
        calculateScrollerConstants()
        
        loadAvatar()
        applyGradient()
        navigationItem.title = userPresenter!.login()
        
        rankingsTable.registerReusableCell(RankingCell)
        
        Users.GetOne(login: userPresenter!.login()).call(success: userSuccess, failure: failure)
    }
    
    @IBAction private func showUserOptions() {
        let userUrl = userPresenter!.gitHubUrl
        let actionsBuilder = RepositoryOptionsBuilder.build(userUrl) { [weak self] in
            guard let s = self else { return }
            let activityViewController = UIActivityViewController(activityItems: [userUrl as NSString], applicationActivities: nil)
            s.presentViewController(activityViewController, animated: true, completion: {})
        }
        presentViewController(actionsBuilder, animated: true, completion: nil)
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
        locationTransformRelation = (locationTransformMin - 1) / profileExtendedBGHeight
    }
    
    private func loadAvatar() {
        if let avatarUrl = userPresenter!.avatarUrl() {
            guard avatarUrl != "" else { return }
            avatarImageView.fetchAndLoad(avatarUrl) {
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
        return kColors.userGradientColors.map { UIColor(hex: $0).CGColor }
    }
    
    private func calculateScrollerConstants() {
        halfWidth = view.width / 2
        
        avatarTransformRelation = (avatarTransformMin - 1) / profileExtendedBGHeight
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
        if totalWidth + totalSpacingBetweenViews > view.width {
            return false
        }
        return true
    }
}

// Mark - Fetch callbacks
extension UserDetailsController {
    func userSuccess(user: User) {
        userPresenter = UserPresenter(user: user)
        loadAvatar()
        applyReposStarsAndTrophiesLabelsFor(user)
        countryAndCityLabel.text = userPresenter!.fullLocation
        rankings = user.rankings
        loadingView.hidden = true
        addItemsToTable()
        rankingsTable.reloadData()
        
    }
    
    func addItemsToTable() {
        addAnotherCell()
        timer = NSTimer.scheduledTimerWithTimeInterval(cellInsertionInterval, target: self, selector: #selector(addAnotherCell), userInfo: nil, repeats: true)
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
    
    func failure(apiResponse: ApiResponse) {
        loadingView.hidden = true
        NotifyError.display()
    }
    
    private func applyReposStarsAndTrophiesLabelsFor(user: User) {
        totalReposLabel.text = "\(userPresenter!.totalRepositories)"
        totalStarsLabel.text = "\(userPresenter!.totalStars)"
        totalLanguagesLabel.text = "\(user.rankings.count)"
        totalTrophiesLabel.text = "\(userPresenter!.totalTrophies)"
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
        
        let contentHeight = scrollView.contentSize.height
        let rowsHeight = contentHeight - profileMinBGHeight

        if rowsHeight <= scrollView.height + profileExtendedBGHeight {
            return
        }
        
        let y = scrollView.contentOffset.y
        
        if y < profileExtendedBGHeight && y >= 0 {
            moveFor(y)
        } else {
            if y > profileExtendedBGHeight {
                moveFor(CGFloat(profileExtendedBGHeight))
            } else if y < 0 {
                moveFor(CGFloat(0))
            }
        }
    }
    
    private func moveFor(offset: CGFloat) {
        // Plenty of y = mx + b now.
        
        let profileBgHeight = (profileMinBGHeight / profileExtendedBGHeight) * offset + profileExtendedBGHeight
        profileTopConstraint.constant = profileExtendedBGHeight - profileBgHeight
        statsContainer.alpha = 1 - (offset / profileExtendedBGHeight)
        
        if userPresenter!.hasLocation() { moveLocationLabel(offset) }
        moveAvatar(offset)
        moveButton(offset)
    }
    
    private func moveLocationLabel(y: CGFloat) {
        if locationTransformRelation == nil {
            locationTransformRelation = avatarTransformRelation
        }
        let transformSize = locationTransformRelation * y + 1
        countryAndCityLabel.transform = CGAffineTransformScale(originalLocationTransform, transformSize, transformSize)
        
        locationTopConstraint.constant = -(70 / profileExtendedBGHeight) * y + 90
        locationCenterConstraint.constant = -((halfWidth - countryAndCityLabel.halfWidth - avatarBackground.frame.width - 20) / profileExtendedBGHeight) * y
    }
    
    private func moveAvatar(y: CGFloat) {
        let transformSize = avatarTransformRelation * y + 1
        avatarBackground.transform = CGAffineTransformScale(originalAvatarTransform, transformSize, transformSize)
        
        avatarTopConstraint.constant = -(15 / profileExtendedBGHeight) * y + 10
        avatarCenterXConstraint.constant = -((halfWidth - avatarBackground.halfWidth - 10) / profileExtendedBGHeight) * y
    }
    
    private func moveButton(y: CGFloat) {
        buttonCenterConstraint.constant = (((halfWidth - viewOnGithubButton.halfWidth - 10) / profileExtendedBGHeight) * y)
        buttonTopConstraint.constant = 118 - ((102 / profileExtendedBGHeight) * y)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return userPresenter!.hasLocation() ? 158 : 78
    }
}

extension UserDetailsController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempRankings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellFor(indexPath) as RankingCell
        cell.rankingPresenter = RankingPresenter(ranking: rankings[indexPath.row])
        return cell
    }
}