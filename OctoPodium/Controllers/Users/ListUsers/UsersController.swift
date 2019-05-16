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
    
    var selectedLocationType = LocationType.world
    
    var navigationControl: UINavigationController?
    
    var selectedIndexPath: IndexPath?
    
    var swipeInteractionController = SwipeInteractionController()
    
    var imageViewForSelectedIndexPath: UIImageView!
    
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
    
    func selectedCell() -> UITableViewCell {
        return usersTable.cellForRow(at: selectedIndexPath!)!
    }
    
    func search(_ locationName: String? = "") {
        setNewSearchingState()
        self.locationName = locationName!
        searchUsers(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedIndex = usersTable.indexPathForSelectedRow

        if (segue.identifier == kSegues.userDetailsSegue && selectedIndex != nil) {
            usersTable.deselectRow(at: selectedIndex!, animated: true)
            let destVC = segue.destination as! UserDetailsController
            let user = usersTableDataSource.item(at: selectedIndex!)
            destVC.userPresenter = UserPresenter(user: user)

            if CurrentUser.hasAnimationsEnabled {
                swipeInteractionController.wireToViewController(destVC)
                navigationController?.delegate = self
            }
        }
    }
    
    @objc func freshSearchUsers() {
        searchUsers(true)
    }
    
    func searchUsers(_ reset: Bool = false) {
        if reset {
            usersTable.hide()
        }
        
        userSearchOptions.locationType = selectedLocationType
        userSearchOptions.location = locationName
        
        usersTableDataSource.searchUsers(reset)
        sendSearchedLocationToAnalytics()
    }
    
    func sendSearchedLocationToAnalytics() {
        //To be overriden
    }
    
    func stopLoadingIndicator() {
        usersTable.stopLoadingIndicator()
    }
    
    private func updateRefreshControl() {
        usersTable.updateRefreshControl()
    }
    
    func sendUserPaginatedToAnalytics(_ page: String) {
        //To be overriden
    }
}

extension UsersController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath as NSIndexPath).row < 3 ? 60 : 44
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let lastItemRow = (usersTable.indexPathsForVisibleRows?.last as NSIndexPath?)?.row {
            let total = usersTableDataSource.totalCount
            paginationLabel.text = "\(lastItemRow + 1)/\(total)"
        }
        
//        updateRefreshControl()
        
//        if usersTable.isRefreshing() {
//            searchUsers(true)
//            return
//        }
        
        if usersTableDataSource.hasMorePages {
            searchUsersIfTableReady()
        }
    }
    
    func searchUsersIfTableReady() {
        if !usersTable.isFooterVisible() {
            return
        }
        
        searchUsers(false)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath

        let cell = tableView.cellForRow(at: indexPath) as! CellWithAvatar
        imageViewForSelectedIndexPath = cell.avatar
        
        performSegue(withIdentifier: kSegues.userDetailsSegue, sender: self)
    }
    
}

extension UsersController : TableStateListener {

    func newDataArrived<User>(_ page: Page<User>) {

        page.isLastPage ? usersTable.hideFooter() : usersTable.showFooter()

        if page.isFirstPage {
            paginationLabel.text = "1/\(page.totalCount)"
        } else {
            sendUserPaginatedToAnalytics("\(page.currentPage)")
        }
        
        usersTable.reloadData()
        if page.totalCount == 0 {
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
    
    func failedToGetData(_ status: NetworkStatus) {
//        stopLoadingIndicator()
        usersTable.show()
        Notification.shared.display(.error(status.message()))
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

extension UsersController : UINavigationControllerDelegate {

    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {

        guard CurrentUser.hasAnimationsEnabled else { return nil }
        
        if operation == .push {
            return UserDetailsPresentAnimator()
        } else {
            return UserDetailsDismissAnimator()
        }
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        (viewController as? LanguageRankingsController)?.navigationController?.delegate = nil
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {

        guard CurrentUser.hasAnimationsEnabled else { return nil }
        return swipeInteractionController.interactionInProgress ? swipeInteractionController : nil
    }

}
