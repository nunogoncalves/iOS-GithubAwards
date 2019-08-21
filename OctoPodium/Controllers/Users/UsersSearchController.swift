//
//  UsersSearchController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 26/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit
//import SwiftUI
import Xtensions

class UsersSearchController: UIViewController {

    private let searchBar: SearchBar = create {
        $0.placeholder = "Search for a user"
    }

    private let loadingView: GithubLoadingView = create {
        $0.constrainSize(equalTo: Layout.Size.loadingView)
        $0.stop()
        $0.hide()
    }

    private let userContainer: UIStackView = create {
        $0.axis = .vertical
        $0.distribution = .fill
    }

    private let userListInfoView: UserListItemView = create {
        $0.constrain(height: 80)
    }

    private let octocatContainer = UIView.usingAutoLayout()

    private var octocat: UserSearchResultView = create {
        $0.constrainSize(equalTo: 200)
    }

    private let userNotFoundLabel: UILabel = create {
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = UIColor(hex: 0x909095)
        $0.text = "User not found"
        $0.hide()
    }

    weak var coordinator: UserDisplayCoordinator?
    private var user: User?

    init(coordinator: UserDisplayCoordinator) {
        self.coordinator = coordinator

        super.init(nibName: nil, bundle: nil)

        view.addSubview(searchBar)
        view.addSubview(userContainer)
        view.addSubview(octocat)
        view.addSubview(userNotFoundLabel)
        view.addSubview(loadingView)

        userContainer.addArrangedSubview(userListInfoView)
        userListInfoView.isHidden = true

        searchBar.constrain(referringTo: view.safeAreaLayoutGuide, bottom: nil)

        userContainer.constrain(referringTo: view.safeAreaLayoutGuide, top: nil, bottom: nil)
        userContainer.top(==, searchBar.bottomAnchor)

        octocat.center(==, view)
        userNotFoundLabel.top(==, octocat.bottomAnchor, 20)
        userNotFoundLabel.leading(>=, view, 10)
        userNotFoundLabel.trailing(<=, view, -10)
        userNotFoundLabel.centerX(==, view)
        loadingView.center(==, view)

        searchBar.delegate = self

        view.addSubview(octocatContainer)
        octocatContainer.constrainSize(equalTo: 200)
//        octocatContainer.backgroundColor = .red
        octocatContainer.center(==, view)

//        octocatSwiftUI = OctoCatView(eyesOpened: found)
//        let hosting = UIHostingController<OctoCatView>(rootView: octocatSwiftUI)
//        addChild(hosting)
//        octocatContainer.addSubview(hosting.view)
//        hosting.view.pinToBounds(of: octocatContainer)
//        hosting.didMove(toParent: self)
    }

//    var octocatSwiftUI: OctoCatView!
//    var found: Binding<Bool> = .constant(true)

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.becomeFirstResponder()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showUser))
        userContainer.addGestureRecognizer(tapGesture)
        Analytics.SendToGoogle.enteredScreen(kAnalytics.userSearchScreen)
    }

    override func viewWillAppear(_ animated: Bool) {
        if let _ = User.inUserDefaults {
            let meButton = UIBarButtonItem(title: "Me", style: .plain, target: self, action: #selector(selectMe))
            navigationItem.rightBarButtonItem = meButton
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }

    @objc private func selectMe() {
        if let user = User.inUserDefaults {
            searchBar.text = user.login
            performQuery(with: user.login)
            searchBar.resignFirstResponder()
        }
    }

    @objc private func showUser() {
        guard let user = user else { return }
        coordinator?.showDetails(of: user)
    }

    fileprivate func performQuery(with login: String) {
        loadingView.setLoading()
        loadingView.show()
        Users.GetOne(login: login).call(success: gotUser, failure: failedToSearchForUser)
        Analytics.SendToGoogle.userSearched(login)
    }

    private func gotUser(_ user: User) {
        userNotFoundLabel.hide()
        loadingView.hide()
        octocat.render(found: true)

        userListInfoView.render(with: UserPresenter(user: user), withLocation: true)
        userListInfoView.updateStars()

        self.user = user
        UIView.animate(withDuration: .animationDuration) {
            self.userListInfoView.show()
        }
    }

    private func failedToSearchForUser(_ apiResponse: ApiResponse) {
        loadingView.hide()
        userNotFoundLabel.show()
        octocat.render(found: false)

        if apiResponse.status.isTechnicalError() {
            Notification.shared.display(.error(apiResponse.status.message()))
        }

        UIView.animate(withDuration: .animationDuration) {
            self.userListInfoView.hide()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
}

extension UsersSearchController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print((searchBar.text?.count ?? 0) % 2 == 0)
//        found = .constant((searchBar.text?.count ?? 0) % 2 == 0)
//        octocatSwiftUI.eyesOpened = (searchBar.text?.count ?? 0) % 2 == 0

        guard let text = searchBar.text else {
            return
        }

        if text.count > 0 {
            performQuery(with: text)
            searchBar.resignFirstResponder()
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

private extension TimeInterval {
    static let animationDuration: TimeInterval = 0.3
}
