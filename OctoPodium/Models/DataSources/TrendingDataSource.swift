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
    var language = ""
    
    var gotRepositories: (() -> ())?
    var userClicked: ((_ login: String) -> ())?
    var repositoryCellClicked: ((_ repository: Repository) -> ())?
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellFor(indexPath) as TrendingRepositoryCell
        cell.repositorySince = (repository: repositories[indexPath.row], since: trendingScope.message)
        cell.userClicked = userClicked
        return cell
    }
    
    fileprivate func setupCell(_ tableView: UITableView, indexPath: IndexPath) -> TrendingRepositoryCell {
        
        let cell = tableView.dequeueReusableCellFor(indexPath) as TrendingRepositoryCell
        cell.repositorySince = (repository: repositories[indexPath.row], since: trendingScope.message)
        
        return cell
    }
    
    func search() {
        Analytics.SendToGoogle.searchedTrending(trendingScope.rawValue, language: language)
        DispatchQueue.global(qos: .userInteractive).async {
            self.repositories = Repositories.GetRepositories().get(self.trendingScope.rawValue, language: self.language)
            DispatchQueue.main.sync {
                self.gotRepositories?()
                self.tableView.reloadData()
            }
        }
    }
}

extension TrendingDataSource : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        repositoryCellClicked?(repositories[(indexPath as NSIndexPath).row])
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = setupCell(tableView, indexPath: indexPath)
        return calculateHeightForConfiguredSizingCell(cell)
    }
    
    private func calculateHeightForConfiguredSizingCell(_ cell: TrendingRepositoryCell) -> CGFloat {
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        let size = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return size.height
    }
    
}
