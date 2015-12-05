//
//  PaginaTable.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 05/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class PaginaTable: UITableView {

    var paginator: Paginator?
    
    lazy var height: CGFloat! = {
        return self.frame.size.height
    }()
    
    lazy var footerHeight: CGFloat! = {
        return self.tableFooterView!.frame.height
    }()
    
    func isFooterVisible() -> Bool {
        return contentOffset.y >= (contentSize.height - height)
    }
    
    func showFooter() {
        tableFooterView?.hidden = false
    }
    
    func hideFooter() {
        tableFooterView?.hidden = true
    }
    
}
