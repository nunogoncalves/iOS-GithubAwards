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
    
    override func viewDidLoad() {
        repositoriesTable.dataSource = self
        repositoriesTable.delegate = self
        
        repositoriesTable.registerReusableCell(TrendingRepositoryCell)
        
        repositoriesTable.estimatedRowHeight = 95.0
        repositoriesTable.rowHeight = UITableViewAutomaticDimension
        
        searchTrendingRepos()
        buildSegmentedControl()
    }
    
    private func searchTrendingRepos() {
        repositoriesTable.hide()
        loadingView.show()
        loadingView.setLoading()
        
        let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) {
            self.repositories = Repositories.GetRepositories().get(self.selectedTrendingScope.rawValue)
            dispatch_sync(dispatch_get_main_queue()) {
                self.loadingView.hide()
                self.repositoriesTable.show()
                self.repositoriesTable.reloadData()
            }
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
        searchTrendingRepos()
    }
}

extension TrendingController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return setupCell(tableView, indexPath: indexPath)
    }
    
    private func setupCell(tableView: UITableView, indexPath: NSIndexPath) -> TrendingRepositoryCell {
        
        let cell = tableView.dequeueReusableCellFor(indexPath) as TrendingRepositoryCell
        
        cell.repositorySince = (repository: repositories[indexPath.row], since: selectedTrendingScope.message)
        
        return cell
    }
    
}

extension TrendingController : UITableViewDelegate {
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = setupCell(tableView, indexPath: indexPath)
        return calculateHeightForConfiguredSizingCell(cell)
    }
    
    private func calculateHeightForConfiguredSizingCell(cell: TrendingRepositoryCell) -> CGFloat {
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        let size = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        return size.height
    }

}