//
//  UsersController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 07/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class UsersController : UIViewController {
    
    var usersTable: UsersTable!
    var paginationLabel: UILabel!
    var paginationContainer: UIView!
    var loadingView: GithubLoadingView!
    var emptyMessageLabl: UILabel?
    var noResultsLabl: UILabel!
    
    var usersTableDataSource: LanguageUsersTableDataSource!
    let userSearchOptions = SearchOptions()
    
    var selectedLocationType = LocationType.World
    
    var language: String = "" {
        didSet {
            userSearchOptions.language = language
        }
    }
    var locationName: String = "" {
        didSet {
            userSearchOptions.location = locationName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersTableDataSource = LanguageUsersTableDataSource(searchOptions: userSearchOptions)
        usersTableDataSource.tableStateListener = self
        usersTable.dataSource = usersTableDataSource
        usersTable.delegate = self
        usersTable.hideFooter()
        
//        usersTable.addRefreshController(self, action: "freshSearchUsers")
    }
    
    func search(locationName: String? = "") {
        setNewSearchingState()
        self.locationName = locationName!
        searchUsers(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let selectedIndex = usersTable.indexPathForSelectedRow
        
        if (segue.identifier == kSegues.userDetailsSegue && selectedIndex != nil) {
            usersTable.deselectRowAtIndexPath(selectedIndex!, animated: true)
            let destVC = segue.destinationViewController as! UserDetailsController
            destVC.user = usersTableDataSource.dataForIndexPath(selectedIndex!) as? User
        }
    }
    
    @objc func freshSearchUsers() {
        searchUsers(true)
    }
    
    func searchUsers(reset: Bool = false) {
        if reset {
            usersTable.hide()
        }
        
        userSearchOptions.locationType = selectedLocationType
        userSearchOptions.location = locationName
        
        usersTableDataSource.searchUsers(reset)
    }
    
    func stopLoadingIndicator() {
        usersTable.stopLoadingIndicator()
    }
    
    private func updateRefreshControl() {
        usersTable.updateRefreshControl()
    }
}

extension UsersController : UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row < 3 ? 60 : 44
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let lastItemRow = usersTable.indexPathsForVisibleRows?.last?.row {
            let total = usersTableDataSource.getTotalCount()
            paginationLabel.text = "\(lastItemRow + 1)/\(total)"
        }
        
//        updateRefreshControl()
        
//        if usersTable.isRefreshing() {
//            searchUsers(true)
//            return
//        }
        
        if usersTableDataSource.hasMoreDataAvailable() {
            searchUsersIfTableReady()
        }
    }
    
    func searchUsersIfTableReady() {
        if !usersTable.isFooterVisible() {
            return
        }
        
        searchUsers(false)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(kSegues.userDetailsSegue, sender: self)
    }
    
}

extension UsersController : TableStateListener {
    func newDataArrived(paginator: Paginator) {
        paginator.isLastPage() ? usersTable.hideFooter() : usersTable.showFooter()
        if paginator.isFirstPage() {
            paginationLabel.text = "1/\(paginator.totalCount)"
        }
        usersTable.reloadData()
        if paginator.totalCount == 0 {
            paginationContainer.hide()
            noResultsLabl.show()
            usersTable.hide()
        } else {
            paginationContainer.show()
            usersTable.show()
            noResultsLabl.hide()
        }
        loadingView.hide()
//        stopLoadingIndicator()
    }
    
    func failedToGetData(status: NetworkStatus) {
//        stopLoadingIndicator()
        usersTable.show()
        NotifyError.display(status.message())
    }
    
}

// MARK: - States
extension UsersController {
    func setNewSearchingState() {
        loadingView.show()
        noResultsLabl.hide()
        loadingView.setLoading()
        usersTable.hide()
        emptyMessageLabl?.hide()
    }
    
    func setHasDataState() {
        loadingView.show()
        loadingView.setLoading()
        usersTable.hide()
        emptyMessageLabl?.hide()
    }
    
    func setEmptyState() {
        loadingView.show()
        loadingView.setLoading()
        usersTable.hide()
        emptyMessageLabl?.hide()
    }
}

