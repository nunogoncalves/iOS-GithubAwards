//
//  LanguagesController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 25/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

typealias Language = String

class LanguagesController: UIViewController {

    private let searchBar: SearchBar = create {
        UIView.set($0.heightAnchor, 44)
        $0.barTintColor = UIColor(hex: 0xF3F3F3)
        $0.placeholder = "Filter"
    }
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain).usingAutoLayout()
        table.contentInset.top = 44
        table.register(LanguageCell.self)
        return table
    }()
    private let loadingIndicator: GithubLoadingView = create {
        UIView.set($0.widthAnchor, 90)
        UIView.set($0.heightAnchor, 90)
    }

    private let tryAgainButton: UIButton = create {
        $0.setTitle("Try again", for: .normal)
        $0.setTitleColor(UIColor(hex: 0x0A60FE), for: .normal)
        $0.addTarget(self, action: #selector(LanguagesController.searchLanguages), for: .touchUpInside)
    }

    fileprivate var allLanguages: [Language] = []
    fileprivate var filteredLanguages: [String] = []
    fileprivate var selectedLanguage: Language?

    private weak var coordinator: MainCoordinator?

    init(coordinator: MainCoordinator?) {
        self.coordinator = coordinator

        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(searchBar)
        view.addSubview(loadingIndicator)
        view.addSubview(tryAgainButton)

        searchBar.constrain(referringTo: view.safeAreaLayoutGuide, bottom: nil)

        tableView.pinToBounds(of: view)

        loadingIndicator.centerX(==, view)
        loadingIndicator.centerY(==, view)

        tryAgainButton.centerX(==, view)
        tryAgainButton.centerY(==, view)

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.searchDelegate = self
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        title = "Languages"
        searchLanguages()
        Analytics.SendToGoogle.enteredScreen(kAnalytics.languagesScreen)
    }

    @objc private func searchLanguages() {
        setSearching()
        Languages.Get().getAll(success: got, failure: failedToLoadLanguages)
    }

    private func setSearching() {
        tableView.hide()
        tryAgainButton.hide()
        loadingIndicator.show()
    }

    fileprivate func endSearching() {
        tableView.show()
        tryAgainButton.hide()
        loadingIndicator.hide()
    }
}

extension LanguagesController {

    fileprivate func got(languages: [Language]) {

        self.allLanguages = languages
        self.filteredLanguages = allLanguages
        
        tableView.reloadData()
        endSearching()
    }
    
    fileprivate func failedToLoadLanguages(_ apiResponse: ApiResponse) {
        tryAgainButton.show()
        loadingIndicator.hide()
        Notification.shared.display(.error(apiResponse.status.message()))
    }
}

extension LanguagesController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLanguage = filteredLanguages[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: false)
        coordinator?.showDetails(of: selectedLanguage!)
    }
}

extension LanguagesController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LanguageCell = tableView.dequeueCell(for: indexPath)
        cell.render(with: filteredLanguages[indexPath.row])
        return cell
    }
}

extension LanguagesController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filteredLanguages = allLanguages
        } else {
            let resultPredicate = NSPredicate(format: "self contains[c] %@", searchText)
            filteredLanguages = allLanguages.filter { resultPredicate.evaluate(with: $0) }
        }
        tableView.reloadData()
    }
}
