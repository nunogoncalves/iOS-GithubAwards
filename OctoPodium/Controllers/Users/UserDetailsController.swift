//
//  UserDetailsController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

private enum ScrollingArea {
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

    private let userInfoView = UserInfoView.usingAutoLayout()
    private let gradientView = UIView.usingAutoLayout()

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain).usingAutoLayout()
        table.register(RankingCell.self)
        table.estimatedRowHeight = .estimatedCellHeight
        table.rowHeight = UITableView.automaticDimension
        table.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: UserInfoView.maxHeight))
        table.separatorStyle = .none
        return table
    }()

    private let loadingView: GithubLoadingView = create { $0.constrainSize(equalTo: Layout.Size.loadingView) }

    private var userPresenter: UserPresenter
    private var rankings: [Ranking] = []

    private let profileMinHeight = UserInfoView.minHeight
    private let profileMaxHeight = UserInfoView.maxHeight

    private var gradientBottomConstraint: NSLayoutConstraint!

    init(user: User) {
        userPresenter = UserPresenter(user: user)

        super.init(nibName: nil, bundle: nil)

        addSubviews()
        addSubviewConstraints()

        tableView.delegate = self
        tableView.dataSource = self
    }

    private func addSubviews() {
        view.backgroundColor = .white
        view.addSubviews(tableView, gradientView, userInfoView, loadingView)
    }

    private func addSubviewConstraints() {
        tableView.pinTo(marginsGuide: view.safeAreaLayoutGuide)

        userInfoView.constrain(referringTo: view.safeAreaLayoutGuide, bottom: nil)
        gradientView.constrain(referringTo: view.safeAreaLayoutGuide, top: nil, bottom: nil)
        gradientBottomConstraint = gradientView.bottom(==, userInfoView)
        gradientView.constrain(height: profileMaxHeight)
        userInfoView.render(with: UserInfoView.maxHeight)

        loadingView.center(==, tableView)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        Analytics.SendToGoogle.enteredScreen(kAnalytics.userDetailsScreen(for: userPresenter.user))

        setupNavigationBar()

        userInfoView.render(with: userPresenter)
        navigationItem.title = userPresenter.login

        applyGradient()

        Users.GetOne(login: userPresenter.login).call(success: userSuccess, failure: failure)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyGradient()
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [
            .init(barButtonSystemItem: .action, target: self, action: #selector(showUserOptions))
        ]
        guard userPresenter.user.isSelf else { return }
        navigationItem.rightBarButtonItems?.insert(
            .init(image: #imageLiteral(resourceName: "TwitterIcon"), style: .plain, target: self, action: #selector(shareUserRankingOnTwitter)),
            at: 0
        )
    }

    private var gradientSetup = false

    private func applyGradient() {
        guard gradientSetup == false else { return }
        view.layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = userInfoView.bounds
        guard gradientLayer.frame.width > 0 else { return }
        gradientLayer.colors = UIColor.userGradientColors.map { $0.cgColor }
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        gradientSetup = true
    }

    private func userSuccess(_ user: User) {
        userPresenter = UserPresenter(user: user)
        userInfoView.render(with: userPresenter)
        rankings = user.rankings
        loadingView.isHidden = true
        tableView.reloadData()
    }

    private func failure(_ apiResponse: ApiResponse) {
        loadingView.isHidden = true
        Notification.shared.display(.error("Failed to get user details"))
    }

    @objc private func shareUserRankingOnTwitter() {
        guard rankings.count > 0 else { return }

        let cityRanking = rankings[0].city?.position ?? 0
        let countryRanking = rankings[0].country?.position ?? 0

        let ranking = max(cityRanking, countryRanking)

        if Twitter.Share.needsUrsername {

            let alert = UIAlertController(title: "Enter your twitter account name", message: nil, preferredStyle: .alert )
            alert.addTextField { textField in textField.keyboardType = .alphabet }

            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.shareOnTwitter(username: alert.textFields?.first?.text, ranking: "\(ranking)")
            })

            alert.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in
                self.shareOnTwitter(ranking: "\(ranking)")
            })

            self.present(alert, animated: true, completion: nil)

        } else {
            shareOnTwitter(ranking: "\(ranking)")
        }
    }

    private func shareOnTwitter(username: String? = nil, ranking: String) {
        Twitter.Share.perform(
            ranking: ranking,
            language: rankings[0].language!,
            location: userPresenter.locationName.capitalized,
            username: username
        )
    }

    @objc private func showUserOptions() {
        let userUrl = userPresenter.gitHubUrl
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
}

extension UserDetailsController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RankingCell = tableView.dequeueCell(for: indexPath)
        cell.delegate = self
        cell.render(with: RankingPresenter(ranking: rankings[indexPath.row]))
        return cell
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
        case .pullingDown: userInfoView.render(with: profileMaxHeight)
        case .animationArea: userInfoView.render(with: profileMaxHeight - y)
        case .pastUpThreshold: userInfoView.render(with: profileMinHeight)
        }
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
        Analytics.SendToGoogle.viewUserLanguagesOnGithub(userPresenter.login, language: language)

        let controller = UserLanguageReposotoriesController(user: userPresenter.user, language: language)
        navigationController?.pushViewController(controller, animated: true)
    }
}

private extension CGFloat {
    static let estimatedCellHeight: CGFloat = 150
}
