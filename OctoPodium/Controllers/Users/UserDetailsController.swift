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
    
    
    @IBAction func tweetButtonTapped(_ sender: UIBarButtonItem) {
        guard let userPresenter = userPresenter else { return }
        guard rankings.count > 0 else { return }
        
        let cityRanking = rankings[0].cityRanking ?? 0
        let countryRanking = rankings[0].countryRanking ?? 0
        
        var ranking = cityRanking
        if countryRanking >= cityRanking {
            ranking = countryRanking
        }
        
        _ = Twitter.Share(ranking: "\(ranking)",
                      language: rankings[0].language!,
                      location: userPresenter.cityOrCountryOrWorld.capitalized)
    }
    @IBAction func viewGithubProfileClicked() {
        if let login = userPresenter?.login {
            Browser.openPage("http://github.com/\(login)")
            Analytics.SendToGoogle.viewUserOnGithub(login)
        }
    }
    
    @IBOutlet weak var rankingsTable: UITableView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var rankings = [Ranking]()
    
    weak var timer: Timer!
    fileprivate var tempRankings = [Ranking]()
    
//    var user: User?
    var userPresenter: UserPresenter?
    
    fileprivate var animateCells = true
    
    fileprivate let cellInsertionInterval: TimeInterval = 0.2
    fileprivate let cellAnimationDuration: TimeInterval = 0.1
    
    fileprivate var halfWidth: CGFloat!
    
    fileprivate var originalAvatarTransform: CGAffineTransform!
    fileprivate var originalAvatarBackgroundWidth: CGFloat!

    fileprivate var originalLocationTransform: CGAffineTransform!
    fileprivate var locationTransformRelation: CGFloat!
    
    fileprivate let profileExtendedBGHeight: CGFloat = 182
    fileprivate let profileMinBGHeight: CGFloat = 117
    
    fileprivate let avatarTransformMin: CGFloat = 0.5
    fileprivate var avatarTransformRelation: CGFloat!
    
    override func viewDidLoad() {
        Analytics.SendToGoogle.enteredScreen(kAnalytics.userDetailsScreenFor(userPresenter!.user))
        
        if !(userPresenter?.user.isSelf ?? false) {
            navigationItem.rightBarButtonItems = [navigationItem.rightBarButtonItems![0]]
            twitterButton = nil
        }
        
        countryAndCityLabel.text = userPresenter!.fullLocation
        countryAndCityLabel.layoutIfNeeded()
        
        calculateScrollerConstants()
        
        loadAvatar()
        applyGradient()
        navigationItem.title = userPresenter!.login
        
        rankingsTable.registerReusableCell(RankingCell.self)
        
        Users.GetOne(login: userPresenter!.login).call(success: userSuccess, failure: failure)
    }
    
    @IBAction private func showUserOptions() {
        let userUrl = userPresenter!.gitHubUrl
        let actionsBuilder = RepositoryOptionsBuilder.build(userUrl) { [weak self] in
            guard let s = self else { return }
            let activityViewController = UIActivityViewController(activityItems: [userUrl as NSString], applicationActivities: nil)
            s.present(activityViewController, animated: true, completion: {})
        }
        present(actionsBuilder, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if timer != nil {
            invalidateTimer()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        let locationTransformMin = calculateLocationTransformMin()
        locationTransformRelation = (locationTransformMin - 1) / profileExtendedBGHeight
    }
    
    fileprivate func loadAvatar() {
        if let avatarUrl = userPresenter!.avatarUrl {
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
        profileBackgroundView.layer.insertSublayer(gradient, at: 0)
    }
    
    private func buidGradientOfColors() -> [CGColor] {
        return kColors.userGradientColors.map { UIColor(hex: $0).cgColor }
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
    func userSuccess(_ user: User) {
        userPresenter = UserPresenter(user: user)
        loadAvatar()
        applyReposStarsAndTrophiesLabelsFor(user)
        countryAndCityLabel.text = userPresenter!.fullLocation
        rankings = user.rankings
        loadingView.isHidden = true
        addItemsToTable()
        rankingsTable.reloadData()
        
    }
    
    func addItemsToTable() {
        addAnotherCell()
        timer = Timer.scheduledTimer(timeInterval: cellInsertionInterval, target: self, selector: #selector(addAnotherCell), userInfo: nil, repeats: true)
    }
 
    @objc private func addAnotherCell() {
        if tempRankings.count == rankings.count {
            invalidateTimer()
            return
        }
        
        tempRankings.append(rankings[tempRankings.count])
        rankingsTable.insertRows(at: [IndexPath(row: (tempRankings.count - 1), section: 0)], with: .automatic)
    }
    
    fileprivate func invalidateTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    func failure(_ apiResponse: ApiResponse) {
        loadingView.isHidden = true
        NotifyError.display()
    }
    
    private func applyReposStarsAndTrophiesLabelsFor(_ user: User) {
        totalReposLabel.text = "\(userPresenter!.totalRepositories)"
        totalStarsLabel.text = "\(userPresenter!.totalStars)"
        totalLanguagesLabel.text = "\(user.rankings.count)"
        totalTrophiesLabel.text = "\(userPresenter!.totalTrophies)"
    }
}

extension UserDetailsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !animateCells {
            return
        }

        let center = cell.center
        cell.center = CGPoint(x: center.x - (view.frame.width), y: center.y)
        
        UIView.beginAnimations("position", context: nil)
        UIView.setAnimationDuration(cellAnimationDuration)
        cell.center = center
        UIView.commitAnimations()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
    
    fileprivate func moveFor(_ offset: CGFloat) {
        // Plenty of y = mx + b now.
        
        let profileBgHeight = (profileMinBGHeight / profileExtendedBGHeight) * offset + profileExtendedBGHeight
        profileTopConstraint.constant = profileExtendedBGHeight - profileBgHeight
        statsContainer.alpha = 1 - (offset / profileExtendedBGHeight)
        
        if userPresenter!.hasLocation { moveLocationLabel(offset) }
        moveAvatar(offset)
        moveButton(offset)
    }
    
    fileprivate func moveLocationLabel(_ y: CGFloat) {
        if locationTransformRelation == nil {
            locationTransformRelation = avatarTransformRelation
        }
        let transformSize = locationTransformRelation * y + 1
        countryAndCityLabel.transform = originalLocationTransform.scaledBy(x: transformSize, y: transformSize)
        
        locationTopConstraint.constant = -(70 / profileExtendedBGHeight) * y + 90
        locationCenterConstraint.constant = -((halfWidth - countryAndCityLabel.halfWidth - avatarBackground.frame.width - 20) / profileExtendedBGHeight) * y
    }
    
    fileprivate func moveAvatar(_ y: CGFloat) {
        let transformSize = avatarTransformRelation * y + 1
        avatarBackground.transform = originalAvatarTransform.scaledBy(x: transformSize, y: transformSize)
        
        avatarTopConstraint.constant = -(15 / profileExtendedBGHeight) * y + 10
        avatarCenterXConstraint.constant = -((halfWidth - avatarBackground.halfWidth - 10) / profileExtendedBGHeight) * y
    }
    
    fileprivate func moveButton(_ y: CGFloat) {
        buttonCenterConstraint.constant = (((halfWidth - viewOnGithubButton.halfWidth - 10) / profileExtendedBGHeight) * y)
        buttonTopConstraint.constant = 118 - ((102 / profileExtendedBGHeight) * y)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return userPresenter!.hasLocation ? 158 : 78
    }
}

extension UserDetailsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempRankings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellFor(indexPath) as RankingCell
        cell.rankingPresenter = RankingPresenter(ranking: rankings[indexPath.row])
        return cell
    }
}
