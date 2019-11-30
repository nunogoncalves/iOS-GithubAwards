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
//    var refreshController = UIRefreshControl()

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
    
//    func addRefreshController(_ refreshActionTarget: AnyObject, action: Selector) {
//        refreshController = UIRefreshControl()
//        refreshController!.backgroundColor = UIColor.clear
//        refreshController!.tintColor = UIColor.clear
//
//        refreshController!.addTarget(refreshActionTarget, action: action, for:.valueChanged)
//
//        addLoadingViewToRefreshControl()
//        addRefreshControl()
//    }

//    private func addLoadingViewToRefreshControl() {
//        loadingView = GithubLoadingView(frame: refreshController.bounds)
//        refreshController.addSubview(loadingView)
//    }

//    private func addRefreshControl() {
//        addSubview(refreshController)
//        layoutIfNeeded()
//    }
//
//    func updateRefreshControl() {
//        if refreshController.isRefreshing {
//            loadingView.setLoading()
//        } else {
//            let y = contentOffset.y
//            let perc = y * 100 / 220
//            loadingView.fix(at: Int(abs(perc)), offset: y)
//        }
//    }
//
//    func isRefreshing() -> Bool {
//        return refreshController.isRefreshing
//    }
//
//    func stopLoadingIndicator() {
//        refreshController.endRefreshing()
//    }    
}
