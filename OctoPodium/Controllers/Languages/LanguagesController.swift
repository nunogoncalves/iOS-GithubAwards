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
    
    private var allLanguages: [Language] = []
    private var displayingLanguages = [String]()
    private var selectedLanguage: Language!
    
    override func viewDidLoad() {
        searchBar.searchDelegate = self
        searchLanguages()
        languagesTable.registerReusableCell(LanguageCell)
        Analytics.SendToGoogle.enteredScreen(kAnalytics.languagesScreen)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kSegues.showLanguageRankingSegue {
            segue.rankingsController().language = selectedLanguage
        }
    }
    
    private func searchLanguages() {
        setSearching()
        Languages.Get().getAll(success: gotLanguages, failure: failedToLoadLanguages)
    }
    
    private func setSearching() {
        languagesTable.hide()
        tryAgainButton.hide()
        loadingIndicator?.show()
    }
    
    private func endSearching() {
        languagesTable.show()
        tryAgainButton.hide()
        loadingIndicator?.hide()
    }
}

extension LanguagesController {
    private func gotLanguages(_ languages: [Language]) {
        self.allLanguages = languages
        self.displayingLanguages = allLanguages
        
        languagesTable.reloadData()
        endSearching()
    }
    
    private func failedToLoadLanguages(_ apiResponse: ApiResponse) {
        tryAgainButton.show()
        loadingIndicator?.hide()
        NotifyError.display(apiResponse.status.message())
    }
}

extension LanguagesController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedLanguage = displayingLanguages[(indexPath as NSIndexPath).row]
        performSegue(withIdentifier: kSegues.showLanguageRankingSegue, sender: self)
        languagesTable.deselectRow(at: indexPath, animated: false)
    }
}

extension LanguagesController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayingLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellFor(indexPath) as LanguageCell
        cell.language = displayingLanguages[indexPath.row]
        return cell
    }
}

extension LanguagesController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            displayingLanguages = allLanguages
        } else {
            let resultPredicate = Predicate(format: "self contains[c] %@", searchText)
            displayingLanguages = allLanguages.filter { resultPredicate.evaluate(with: $0) }
        }
        languagesTable.reloadData()
    }
}

private extension UIStoryboardSegue {
    func rankingsController() -> LanguageRankingsController {
        return destinationViewController as! LanguageRankingsController
    }
}
