//
//  ViewController.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class LanguageRankingsController: UIViewController {

    @IBOutlet weak var usersTable: PaginaTable!
    @IBOutlet weak var searchContainer: UIView!

    @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchBar: SearchBar!
    
    @IBOutlet weak var paginationLabel: UILabel!
    
    @IBAction func locationTypeChanged(locationTypeControl: UISegmentedControl) {
        selectedLocationType = locationTypes[locationTypeControl.selectedSegmentIndex]!
        tableTopConstraint.constant = selectedLocationType.hasName() ? 50 : 10
        if selectedLocationType.hasName() {
            searchBar.placeholder = "Insert a \(selectedLocationType.rawValue)"
        }
        animateLocationTypeChanged()
    }
    
    private func animateLocationTypeChanged() {
        UIView.animateWithDuration(0.5) { [weak self] in
            self?.view.layoutIfNeeded()
            self?.searchContainer.alpha = self!.selectedLocationType.hasName() ? 1.0 : 0.0
        }
    }
    
    @IBAction func searchClicked() {
        searchUsers(true)
    }

    @IBOutlet weak var locationNameTextField: UITextField!
    
    let locationTypes: [Int : LocationType] = [0 : .World, 1 : .Country, 2 : .City]
    var selectedLocationType = LocationType.World

    var language: String? {
        didSet {
            let lang = language ?? ""
            navigationItem.title = language
            userSearchOptions.language = lang
            languageTitleView.language = lang
        }
    }
    
    let languageTitleView = LanguageTitleView(frame: CGRectMake(0.0, 0.0, 120.0, 40.0))
    
    var usersTableDataSource: LanguageUsersTableDataSource!
    let userSearchOptions = SearchOptions()
    var latestUserResponse: UsersListResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchDelegate = self
        usersTable.delegate = self
        usersTableDataSource = LanguageUsersTableDataSource(searchOptions: userSearchOptions)
        usersTableDataSource.tableStateListener = self
        usersTable.dataSource = usersTableDataSource
        usersTable.hideFooter()
        
        usersTable.addRefreshController(self, action: "freshSearchUsers")
        freshSearchUsers()
   }
    
    @objc private func freshSearchUsers() {
        searchUsers(true)
    }
    
    func searchUsers(reset: Bool = false) {
        userSearchOptions.locationType = selectedLocationType
        userSearchOptions.location = searchBar.text!
        
        usersTableDataSource.searchUsers(reset)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.titleView = languageTitleView;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let selectedIndex = usersTable.indexPathForSelectedRow
        
        if (segue.identifier == kSegues.userDetailsSegue && selectedIndex != nil) {
            usersTable.deselectRowAtIndexPath(selectedIndex!, animated: true)
            let destVC = segue.destinationViewController as! UserDetailsController
            destVC.user = usersTableDataSource.dataForIndexPath(selectedIndex!) as? User
        }
    }
    
}

extension LanguageRankingsController : UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row < 3 ? 60 : 44
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let lastItemRow = usersTable.indexPathsForVisibleRows?.last?.row {
            let total = usersTableDataSource.getTotalCount()
            paginationLabel.text = "\(lastItemRow + 1)/\(total)"
        }
        
        updateRefreshControl()
        
        if usersTable.isRefreshing() {
            searchUsers(true)
            return
        }
        
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
    
    private func updateRefreshControl() {
        usersTable.updateRefreshControl()
    }
    
    func stopLoadingIndicator() {
        usersTable.stopLoadingIndicator()
    }
}

extension LanguageRankingsController : TableStateListener {
    func newDataArrived(paginator: Paginator) {
        paginator.isLastPage() ? usersTable.hideFooter() : usersTable.showFooter()
        usersTable.reloadData()
        stopLoadingIndicator()
    }
    
    func failedToGetData() {
        stopLoadingIndicator()
        NotifyError.display()
    }
}

extension LanguageRankingsController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        userSearchOptions.locationType = selectedLocationType
        userSearchOptions.location = searchBar.text!
        freshSearchUsers()
    }
}
