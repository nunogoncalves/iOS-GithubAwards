//
//  TableDataSource.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 05/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

protocol TableViewDataSource: UITableViewDataSource {

    associatedtype PaginatedItem

    var page: Page<PaginatedItem> { get }
    
    func cellIdentifier(for indexPath: IndexPath) -> String
    
    func item(at indexPath: IndexPath) -> PaginatedItem
}
