//
//  UserDetailsController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

enum ScrollingArea {
    case pullingDown
    case animationArea
    case pastUpThreshold

    init(offset: CGFloat, upThreshold: CGFloat) {
        if offset <= 0 {
            self = .pullingDown
        } else {
            if offset <= upThreshold {
                self = .animationArea
            } else {
                self = .pastUpThreshold
            }
        }
    }
}

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
    
    @IBOutlet weak var statsContainer: UserStatsView!

    @IBOutlet weak var twitterButton: UIBarButtonItem!
    
    @IBAction func tweetButtonTapped(_ sender: UIBarButtonItem) {
        guard let userPresenter = userPresenter else { return }
        guard rankings.count > 0 else { return }
        
        let cityRanking = rankings[0].city?.position ?? 0
        let countryRanking = rankings[0].country?.position ?? 0
        
        var ranking = cityRanking
        if countryRanking >= cityRanking {
            ranking = countryRanking
        }

        if Twitter.Share.needsUrsername {

            let alert = UIAlertController(
                title: "Enter your twitter account name",
                message: nil,
                preferredStyle: .alert
            )
            alert.addTextField { (textField) in
                // optionally configure the text field
                textField.keyboardType = .alphabet
            }

            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                
                Twitter.Share.perform(
                    ranking: "\(ranking)",
                    language: self.rankings[0].language!,
                    location: userPresenter.locationName.capitalized,
                    username: alert.textFields?.first?.text
                )
            }
            alert.addAction(okAction)

            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in

                Twitter.Share.perform(
                    ranking: "\(ranking)",
                    language: self.rankings[0].language!,
                    location: userPresenter.locationName.capitalized
                )
            }
            alert.addAction(cancelAction)

            self.present(alert, animated: true, completion: nil)

        } else {
            Twitter.Share.perform(
                ranking: "\(ranking)",
                language: rankings[0].language!,
                location: userPresenter.locationName.capitalized
            )
        }

    }
    @IBAction func viewGithubProfileClicked() {
        if let login = userPresenter?.login {
            Browser.openPage(URL(string: "http://github.com/\(login)")!)
            Analytics.SendToGoogle.viewUserOnGithub(login)
        }
    }
    
    @IBOutlet weak var rankingsTable: UITableView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    private var rankings: [Ranking] = []

    var userPresenter: UserPresenter?

    fileprivate var halfWidth: CGFloat!
    
    fileprivate var originalAvatarTransform: CGAffineTransform!

    fileprivate var originalLocationTransform: CGAffineTransform!
    fileprivate var locationTransformRelation: CGFloat!
    
    fileprivate let profileMaxHeight: CGFloat = 182
    fileprivate let profileMinHeight: CGFloat = 117
    
    fileprivate let avatarTransformMin: CGFloat = 0.5
    fileprivate var avatarTransformRelation: CGFloat!
    
    override func viewDidLoad() {
        Analytics.SendToGoogle.enteredScreen(kAnalytics.userDetailsScreenFor(userPresenter!.user))
        
        if userPresenter?.user.isSelf == false {
            navigationItem.rightBarButtonItems = [navigationItem.rightBarButtonItems![0]]
            twitterButton = nil
        }
        
        countryAndCityLabel.text = userPresenter!.fullLocation
        countryAndCityLabel.layoutIfNeeded()
        
        calculateScrollerConstants()
        
        loadAvatar()
        applyGradient()
        navigationItem.title = userPresenter!.login
        
        rankingsTable.register(RankingCell.self)
        rankingsTable.estimatedRowHeight = 150
        rankingsTable.rowHeight = UITableView.automaticDimension
        Users.GetOne(login: userPresenter!.login).call(success: userSuccess, failure: failure)
    }
    
    @IBAction private func showUserOptions() {
        let userUrl = userPresenter!.gitHubUrl
        let actionsBuilder = RepositoryOptionsBuilder.build(URL(string: userUrl)!) { [weak self] in
            guard let s = self else { return }
            let activityViewController = UIActivityViewController(
                activityItems: [userUrl as NSString],
                applicationActivities: nil
            )
            s.present(activityViewController, animated: true, completion: {})
        }
        present(actionsBuilder, animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationTransformRelation = (minimumLocationTransform - 1) / profileMaxHeight
    }
    
    fileprivate func loadAvatar() {
        guard let avatarUrl = userPresenter!.avatarUrl, avatarUrl != "" else { return }
        avatarImageView.fetchAndLoad(avatarUrl) {
            self.loading.stopAnimating()
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
        return UIColor.userGradientColors.map { $0.cgColor }
    }
    
    private func calculateScrollerConstants() {
        halfWidth = view.width / 2
        
        avatarTransformRelation = (avatarTransformMin - 1) / profileMaxHeight
        originalAvatarTransform = avatarBackground.transform

        originalLocationTransform = countryAndCityLabel.transform
    }
    
    private var minimumLocationTransform: CGFloat {
        guard doesLocationLabelFitsBetweenImageAndButton == false else { return 1.0 }
        
        let labelWidth = countryAndCityLabel.width
        let freeSpace = view.width - (avatarTransformMin * avatarBackground.width) - viewOnGithubButton.width - 40
        
        return freeSpace / labelWidth
    }
    
    private var doesLocationLabelFitsBetweenImageAndButton: Bool {
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
        statsContainer.render(with: userPresenter!.rankingInfo)
        countryAndCityLabel.text = userPresenter!.fullLocation
        rankings = user.rankings
        loadingView.isHidden = true
        rankingsTable.reloadData()
    }

    func failure(_ apiResponse: ApiResponse) {
        loadingView.isHidden = true
        Notification.shared.display(.error("Failed to get user details"))
    }
}

extension UserDetailsController: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let contentHeight = scrollView.contentSize.height
        let rowsHeight = contentHeight - profileMinHeight

        // if there are not enough rows we don't animate the header
        guard rowsHeight > scrollView.height + profileMaxHeight else { return }
        
        let y = scrollView.contentOffset.y

        let scrollingArea = ScrollingArea(offset: y, upThreshold: profileMaxHeight)

        switch scrollingArea {
        case .pullingDown:
            setPosition(basedOnOffset: 0)
        case .animationArea:
            setPosition(basedOnOffset: y)
        case .pastUpThreshold:
            setPosition(basedOnOffset: profileMaxHeight)
        }
    }
    
    fileprivate func setPosition(basedOnOffset y: CGFloat) {
        // Plenty of y = mx + b now.
        
        let profileBgHeight = (profileMinHeight / profileMaxHeight) * y + profileMaxHeight
        profileTopConstraint.constant = profileMaxHeight - profileBgHeight
        statsContainer.alpha = 1 - (y / profileMaxHeight)
        
        if userPresenter!.hasLocation { setLocationLabelPosition(basedOn: y) }
        setAvatarPosition(basedOn: y)
        setButtonPosition(basedOn: y)
    }
    
    fileprivate func setLocationLabelPosition(basedOn y: CGFloat) {
        if locationTransformRelation == nil {
            locationTransformRelation = avatarTransformRelation
        }
        let transformSize = locationTransformRelation * y + 1
        countryAndCityLabel.transform = originalLocationTransform.scaledBy(x: transformSize, y: transformSize)
        
        locationTopConstraint.constant = -(70 / profileMaxHeight) * y + 90

        let xPos = (halfWidth - countryAndCityLabel.halfWidth - avatarBackground.frame.width - 20) / profileMaxHeight
        locationCenterConstraint.constant = -xPos * y
    }
    
    fileprivate func setAvatarPosition(basedOn y: CGFloat) {
        let transformSize = avatarTransformRelation * y + 1
        avatarBackground.transform = originalAvatarTransform.scaledBy(x: transformSize, y: transformSize)
        
        avatarTopConstraint.constant = -(15 / profileMaxHeight) * y + 10
        avatarCenterXConstraint.constant = -((halfWidth - avatarBackground.halfWidth - 10) / profileMaxHeight) * y
    }
    
    fileprivate func setButtonPosition(basedOn y: CGFloat) {
        buttonCenterConstraint.constant = (((halfWidth - viewOnGithubButton.halfWidth - 10) / profileMaxHeight) * y)
        buttonTopConstraint.constant = 118 - ((102 / profileMaxHeight) * y)
    }
}

extension UserDetailsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellFor(indexPath) as RankingCell
        cell.delegate = self
        cell.render(with: RankingPresenter(ranking: rankings[indexPath.row]))
        return cell
    }
}

extension UserDetailsController: RankingSelectionDelegate {

    func tappedCity(_ city: String, forLanguage language: String) {
        navigateToRanking(of: language, for: .city(name: city))
    }

    func tappedCountry(_ country: String, forLanguage language: String) {
        navigateToRanking(of: language, for: .country(name: country))
    }

    func tappedWorld(forLanguage language: String) {
        navigateToRanking(of: language, for: .world)
    }

    private func navigateToRanking(of language: String, for locationType: LocationType) {
        #warning("Coordinator please")
        let languageRankingController = LanguageRankingsController(language: language, locationType: locationType)
        navigationController?.pushViewController(languageRankingController, animated: true)
    }

    func tappedLanguage(_ language: String) {
        guard let login = userPresenter?.login else { return }
        Browser.openPage(URL(string: "https://github.com/search?q=user:\(login)+language:\(language)")!)
        Analytics.SendToGoogle.viewUserLanguagesOnGithub(login, language: language)
    }
}
