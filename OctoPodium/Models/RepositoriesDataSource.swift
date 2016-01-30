//
//  RepositoriesDataSource.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 30/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class RepositoriesDataSource : NSObject, UITableViewDataSource {
    
    var tableView: UITableView!
    
    var repositories = [Repository]()

    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func search() {
//        repositories = Repositories.GetRepositories().get()
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TrendingRepository", forIndexPath: indexPath)
        let repository = repositories[indexPath.row]
        cell.textLabel!.text = "\(repository.name) \(repository.stars)"
        return cell
    }
    
    func gotRepositories(repositories: [Repository]) {
        
    }
    
    func failure(status: NetworkStatus) {
        
    }
}
//
//extension RepositoriesDataSource : UITableViewDataSource {
//
//    
//}
