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
    
    var allLanguages: [Language] = []
    
    var displayingLanguages = [String]()
  
    override func viewDidLoad() {
        searchBar.searchDelegate = self
        searchLanguages()
        languagesTable.registerReusableCell(LanguageCell)
        SendToGoogleAnalytics.enteredScreen(kAnalytics.languagesScreen)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        if segue.identifier == kSegues.showLanguageRankingSegue {
            let vc = segue.destinationViewController as! LanguageRankingsController
            vc.language = displayingLanguages[languagesTable.indexPathForSelectedRow!.row]
            languagesTable.deselectRowAtIndexPath(languagesTable.indexPathForSelectedRow!, animated: false)
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
    private func gotLanguages(languages: [Language]) {
        self.allLanguages = languages
        self.displayingLanguages = allLanguages
        
        languagesTable.reloadData()
        endSearching()
    }
    
    private func failedToLoadLanguages(status: NetworkStatus) {
        tryAgainButton.show()
        loadingIndicator?.hide()
        NotifyError.display(status.message())
    }
}

extension LanguagesController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(kSegues.showLanguageRankingSegue, sender: self)
    }
}

extension LanguagesController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayingLanguages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellFor(indexPath) as LanguageCell
        cell.language = displayingLanguages[indexPath.row]
        return cell
    }
}

extension LanguagesController : UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            displayingLanguages = allLanguages
        } else {
            let resultPredicate = NSPredicate(format: "self contains[c] %@", searchText)
            displayingLanguages = allLanguages.filter { resultPredicate.evaluateWithObject($0) }
        }
        languagesTable.reloadData()
    }
}
