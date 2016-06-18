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
        return contentOffset.y >= (contentSize.height - frameHeight) - 150
    }
    
    func showFooter() {
        tableFooterView?.isHidden = false
    }
    
    func hideFooter() {
        tableFooterView?.isHidden = true
    }
    
    func addRefreshController(_ refreshActionTarget: AnyObject, action: Selector) {
        refreshControl = UIRefreshControl()
        refreshControl!.backgroundColor = UIColor.clear()
        refreshControl!.tintColor = UIColor.clear()
        
        refreshControl!.addTarget(refreshActionTarget, action: action, for:.valueChanged)
        
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
        if refreshControl.isRefreshing {
            loadingView.setLoading()
        } else {
            let y = contentOffset.y
            let perc = y * 100 / 220
            loadingView.setStaticWith(Int(abs(perc)), offset: y)
        }
    }
    
    func isRefreshing() -> Bool {
        return refreshControl.isRefreshing
    }
    
    func stopLoadingIndicator() {
        refreshControl.endRefreshing()
    }
    
}
