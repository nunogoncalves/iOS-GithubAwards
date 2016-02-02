//
//  TrendingDataSource.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 02/02/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class TrendingDataSource : NSObject, UITableViewDataSource {
    
    let tableView: UITableView
    var repositories = [Repository]()
    var trendingScope = TrendingScope.Day
    
    var gotRepositories: (() -> ())?
    var userClicked: ((login: String) -> ())?
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellFor(indexPath) as TrendingRepositoryCell
        cell.repositorySince = (repository: repositories[indexPath.row], since: trendingScope.message)
        cell.userClicked = userClicked
        return cell
    }
    
    private func setupCell(tableView: UITableView, indexPath: NSIndexPath) -> TrendingRepositoryCell {
        
        let cell = tableView.dequeueReusableCellFor(indexPath) as TrendingRepositoryCell
        cell.repositorySince = (repository: repositories[indexPath.row], since: trendingScope.message)
        
        return cell
    }
    
    func search() {
        let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) {
            self.repositories = Repositories.GetRepositories().get(self.trendingScope.rawValue)
            dispatch_sync(dispatch_get_main_queue()) {
                self.gotRepositories?()
                self.tableView.reloadData()
            }
        }
    }
}

extension TrendingDataSource : UITableViewDelegate {
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
