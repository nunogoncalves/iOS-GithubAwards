//
//  TableDataSource.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 05/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

protocol TableViewDataSource: UITableViewDataSource {
    
    var book: Book { get }
    
    func cellIdentifierForIndex(indexPath: NSIndexPath) -> String
    
    func dataForIndexPath(indexPath: NSIndexPath) -> AnyObject
    
}
