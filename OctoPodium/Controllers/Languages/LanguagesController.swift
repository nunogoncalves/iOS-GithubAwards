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
    
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet weak var languagesTable: UITableView!
    @IBOutlet weak var loadingIndicator: GithubLoadingView?
    @IBOutlet weak var tryAgainButton: UIButton!
    
    @IBAction func tryAgainClicked() {
        searchLanguages()
    }
    
    fileprivate var allLanguages: [Language] = []
    fileprivate var displayingLanguages: [String] = []
    fileprivate var selectedLanguage: Language!
    
    override func viewDidLoad() {
        searchBar.searchDelegate = self
        languagesTable.contentInset.top = 44
        searchLanguages()
        languagesTable.registerReusableCell(LanguageCell.self)
        Analytics.SendToGoogle.enteredScreen(kAnalytics.languagesScreen)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kSegues.showLanguageRankingSegue {
            segue.rankingsController.language = selectedLanguage
        }
    }
    
    private func searchLanguages() {
        setSearching()
        Languages.Get().getAll(success: got, failure: failedToLoadLanguages)
    }
    
    private func setSearching() {
        languagesTable.hide()
        tryAgainButton.hide()
        loadingIndicator?.show()
    }
    
    fileprivate func endSearching() {
        languagesTable.show()
        tryAgainButton.hide()
        loadingIndicator?.hide()
    }
}

extension LanguagesController {

    fileprivate func got(languages: [Language]) {
        self.allLanguages = languages
        self.displayingLanguages = allLanguages
        
        languagesTable.reloadData()
        endSearching()
    }
    
    fileprivate func failedToLoadLanguages(_ apiResponse: ApiResponse) {
        tryAgainButton.show()
        loadingIndicator?.hide()
        NotifyError.display(apiResponse.status.message())
    }
}

extension LanguagesController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLanguage = displayingLanguages[indexPath.row]
        performSegue(withIdentifier: kSegues.showLanguageRankingSegue, sender: self)
        languagesTable.deselectRow(at: indexPath, animated: false)
    }
}

extension LanguagesController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayingLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LanguageCell = tableView.dequeueReusableCellFor(indexPath)
        cell.language = displayingLanguages[indexPath.row]
        return cell
    }
}

extension LanguagesController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            displayingLanguages = allLanguages
        } else {
            let resultPredicate = NSPredicate(format: "self contains[c] %@", searchText)
            displayingLanguages = allLanguages.filter { resultPredicate.evaluate(with: $0) }
        }
        languagesTable.reloadData()
    }
}

extension UIStoryboardSegue {
    
    fileprivate var rankingsController: LanguageRankingsController {
        return destination as! LanguageRankingsController
    }
}
