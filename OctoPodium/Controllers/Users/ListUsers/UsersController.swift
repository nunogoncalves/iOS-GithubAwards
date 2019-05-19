//
//  UsersController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 07/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class UsersController : UIViewController {
    
    var usersTable = UsersTable(frame: .zero, style: .plain).usingAutoLayout()

    var paginationContainer: UIView = create {
        $0.backgroundColor = UIColor(hex: 0xACACAC)
        UIView.set($0.heightAnchor, 30)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    var paginationLabel: UILabel = create {
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    var loadingView: GithubLoadingView = create {
        UIView.set($0.widthAnchor, 90)
        UIView.set($0.heightAnchor, 90)
    }

    var startSearchingLabel: UILabel = create {
        $0.textColor = UIColor(hex: 0xAAAAAA)
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.isHidden = true
    }

    var noResultsLabel: UILabel = create {
        $0.textColor = UIColor(hex: 0xAAAAAA)
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.isHidden = true
        $0.text = "No results found"
    }
    
    let usersTableDataSource: LanguageUsersTableDataSource
    private let userSearchOptions: SearchOptions
    
    var selectedLocationType: LocationType
    
    var navigationControl: UINavigationController?
    
    var selectedIndexPath: IndexPath?
    
    var swipeInteractionController = SwipeInteractionController()
    
    var imageViewForSelectedIndexPath: UIImageView!
    
    let language: String
    var locationName: String = ""

    init(language: String, locationType: LocationType) {
        self.language = language
        self.locationName = locationType.nameOrEmpty
        selectedLocationType = locationType

        userSearchOptions = SearchOptions(language: language, locationType: locationType, page: 1)

        usersTableDataSource = LanguageUsersTableDataSource(searchOptions: userSearchOptions)
        usersTable.dataSource = usersTableDataSource
        usersTable.hideFooter()

        super.init(nibName: nil, bundle: nil)

        view.addSubview(startSearchingLabel)
        view.addSubview(noResultsLabel)
        view.addSubview(usersTable)
        view.addSubview(paginationContainer)
        paginationContainer.addSubview(paginationLabel)
        view.addSubview(loadingView)

        usersTable.pinToBounds(of: view)
        paginationContainer.constrain(
            referringTo: view.safeAreaLayoutGuide, top: nil, leading: nil, trailing: -10
        )

        paginationLabel.constrain(referringTo: paginationContainer, leading: 10, trailing: -10)

        loadingView.centerX(==, usersTable)
        loadingView.centerY(==, usersTable)

        startSearchingLabel.centerX(==, usersTable)
        startSearchingLabel.centerY(==, usersTable)

        noResultsLabel.centerX(==, usersTable)
        noResultsLabel.centerY(==, usersTable)

        usersTableDataSource.tableStateListener = self
        usersTable.delegate = self

    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        usersTable.addRefreshController(self, action: "freshSearchUsers")
    }
    
    func selectedCell() -> UITableViewCell {
        return usersTable.cellForRow(at: selectedIndexPath!)!
    }
    
    func search(_ locationName: String? = "") {
        setNewSearchingState()
        self.locationName = locationName ?? ""
        searchUsers(true)
    }

    #warning("handle animation code with the coordinator")
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let selectedIndex = usersTable.indexPathForSelectedRow
//
//        if (segue.identifier == kSegues.userDetailsSegue && selectedIndex != nil) {
//            usersTable.deselectRow(at: selectedIndex!, animated: true)
//            let destVC = segue.destination as! UserDetailsController
//            let user = usersTableDataSource.item(at: selectedIndex!)
//            destVC.userPresenter = UserPresenter(user: user)
//
//            if CurrentUser.hasAnimationsEnabled {
//                swipeInteractionController.wireToViewController(destVC)
//                navigationController?.delegate = self
//            }
//        }
//    }

    @objc func freshSearchUsers() {
        searchUsers(true)
    }
    
    func searchUsers(_ reset: Bool = false) {
        if reset {
            usersTable.hide()
        }
        
        userSearchOptions.locationType = selectedLocationType.with(name: locationName)

        usersTableDataSource.searchUsers(reset)
        sendSearchedLocationToAnalytics()
    }
    
    func sendSearchedLocationToAnalytics() {
        //To be overriden
    }
    
    func stopLoadingIndicator() {
//        usersTable.stopLoadingIndicator()
    }
    
    private func updateRefreshControl() {
//        usersTable.updateRefreshControl()
    }
    
    func sendUserPaginatedToAnalytics(_ page: String) {
        //To be overriden
    }
}

extension UsersController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row < 3 ? 60 : 44
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

        let user = usersTableDataSource.item(at: indexPath)
        let userController = UIStoryboard(storyboard: .main).controller(UserDetailsController.self)
        userController.userPresenter = UserPresenter(user: user)
        navigationController?.pushViewController(userController, animated: true)
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
            noResultsLabel.show()
            usersTable.hide()
        } else {
            paginationContainer.show()
            usersTable.show()
            noResultsLabel.hide()
        }
        loadingView.hide()
        stopLoadingIndicator()
    }
    
    func failedToGetData(_ status: NetworkStatus) {
        stopLoadingIndicator()
        usersTable.show()
        Notification.shared.display(.error(status.message()))
    }
    
}

// MARK: - States
extension UsersController {

    func setStartSearching() {
        loadingView.hide()
        noResultsLabel.hide()
        loadingView.stop()
        usersTable.hide()
        startSearchingLabel.show()
        paginationContainer.hide()
    }

    func setNewSearchingState() {
        loadingView.show()
        noResultsLabel.hide()
        loadingView.setLoading()
        usersTable.hide()
        startSearchingLabel.hide()
    }

    func setHasDataState() {
        loadingView.show()
        loadingView.setLoading()
        usersTable.hide()
        startSearchingLabel.hide()
        paginationContainer.show()
    }

    func setEmptyState() {
        loadingView.show()
        loadingView.setLoading()
        usersTable.hide()
        startSearchingLabel.hide()
        paginationContainer.hide()
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
