//
//  PaginaTable.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 05/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class PaginaTable: UITableView {

    var loadingView: GithubLoadingView!
    var refreshControl: UIRefreshControl!
   
    lazy var frameHeight: CGFloat! = {
        return self.frame.size.height
    }()
    
    lazy var footerHeight: CGFloat! = {
        return self.tableFooterView!.frame.height
    }()
    
    func isFooterVisible() -> Bool {
        return contentOffset.y >= (contentSize.height - frameHeight)
    }
    
    func showFooter() {
        tableFooterView?.hidden = false
    }
    
    func hideFooter() {
        tableFooterView?.hidden = true
    }
    
    func addRefreshController(refreshActionTarget: AnyObject, action: Selector) {
        refreshControl = UIRefreshControl()
        refreshControl!.backgroundColor = UIColor.clearColor()
        refreshControl!.tintColor = UIColor.clearColor()
        
        refreshControl!.addTarget(refreshActionTarget, action: action, forControlEvents:.ValueChanged)
        
        addLoadingViewToRefreshControl()
        addRefreshControl()
    }
    
    private func addLoadingViewToRefreshControl() {
        loadingView = GithubLoadingView(frame: refreshControl.bounds)
        refreshControl.addSubview(loadingView.view)
    }
    
    private func addRefreshControl() {
        addSubview(refreshControl)
        layoutIfNeeded()
    }
    
    func updateRefreshControl() {
        if refreshControl.refreshing {
            loadingView.setLoading()
        } else {
            let y = contentOffset.y
            let perc = y * 100 / 220
            loadingView.setStaticWith(Int(abs(perc)), offset: y)
        }
    }
    
    func isRefreshing() -> Bool {
        return refreshControl.refreshing
    }
    
    func stopLoadingIndicator() {
        refreshControl.endRefreshing()
    }
    
}
