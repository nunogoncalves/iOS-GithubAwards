//
//  TrendingController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 29/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class TrendingController : UIViewController {

    @IBOutlet weak var repositoriesTable: UITableView!
    @IBOutlet weak var loadingView: GithubLoadingView!
    
    private var trendingScopes = TrendingScope.enumerateElements
    private var selectedTrendingScope = TrendingScope.Day
    
    private var repositories: [Repository] = []
    private var selectedRepository: Repository?
    
    private var dataSource: TrendingDataSource!
    
    var languageButton: UIButton!
    
    override func viewDidLoad() {
        setupRepositoriesTable()
        buildSegmentedControl()
        searchTrendingRepos()
        
        updateLanguageIcon()
        
        SendToGoogleAnalytics.enteredScreen(String(TrendingController))
    }
    
    var clicked = 0
    
    let images = ["Language", "javascript", "java", "ruby", "swift"]
    
    @objc private func clickedLanguage() {
        clicked += 1
        if clicked == 5 { clicked = 0 }
        updateLanguageIcon()
        
        dataSource.language = clicked == 0 ? "" : images[clicked]
        searchTrendingRepos()
    }
    
    private func updateLanguageIcon() {
        let image = UIImage(named: images[clicked])?.imageWithRenderingMode(.AlwaysOriginal)
        
        languageButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        languageButton.enabled = false
        
        languageButton.addTarget(self, action: "clickedLanguage", forControlEvents: .TouchUpInside)
        languageButton.setBackgroundImage(image, forState: .Normal)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: languageButton)
    }
    
    private func setupRepositoriesTable() {
        dataSource = TrendingDataSource(tableView: repositoriesTable)
        dataSource.userClicked = userClicked
        dataSource.repositoryCellClicked = repositoryCellClicked
        dataSource.gotRepositories = updateAfterResponse
        
        repositoriesTable.dataSource = dataSource
        repositoriesTable.delegate = dataSource
        
        repositoriesTable.registerReusableCell(TrendingRepositoryCell)
        
        repositoriesTable.estimatedRowHeight = 95.0
        repositoriesTable.rowHeight = UITableViewAutomaticDimension
    }
    
    private func searchTrendingRepos() {
        repositoriesTable.hide()
        loadingView.show()
        loadingView.setLoading()
        
        dataSource.search()
    }
    
    private func updateAfterResponse() {
        loadingView.hide()
        repositoriesTable.show()
        languageButton.enabled = true
    }
    
    private func userClicked(user: String) {
        performSegueWithIdentifier(kSegues.trendingToUserDetailsSegue, sender: user)
    }
    
    private func repositoryCellClicked(repository: Repository) {
        selectedRepository = repository
        performSegueWithIdentifier(kSegues.showTrendingRepositoryDetailsSegue, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kSegues.trendingToUserDetailsSegue {
            let vc = segue.destinationViewController as! UserDetailsController
            vc.user = User(login: sender as! String, avatarUrl: "")
        }
        
        if segue.identifier == kSegues.showTrendingRepositoryDetailsSegue {
            let vc = segue.destinationViewController as! TrendingRepositoryDetailsController
            vc.repository = selectedRepository
        }
    }
    
    private func buildSegmentedControl() {
        let segmentedControl = UISegmentedControl(items: trendingScopes.map { $0.rawValue })
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: "updateTrendingScope:", forControlEvents: .ValueChanged)
        self.navigationItem.titleView = segmentedControl
    }
    
    @objc private func updateTrendingScope(control: UISegmentedControl) {
        selectedTrendingScope = trendingScopes[control.selectedSegmentIndex]
        dataSource.trendingScope = selectedTrendingScope
        searchTrendingRepos()
    }
}