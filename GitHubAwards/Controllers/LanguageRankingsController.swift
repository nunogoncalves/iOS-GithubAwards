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
    
    @IBAction func locationTypeChanged(locationTypeControl: UISegmentedControl) {
        selectedLocationType = locationTypes[locationTypeControl.selectedSegmentIndex]!
        tableTopConstraint.constant = selectedLocationType.hasName() ? 50 : 10
        
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
        usersTable.delegate = self
        usersTableDataSource = LanguageUsersTableDataSource(searchOptions: userSearchOptions)
        usersTableDataSource.tableStateListener = self
        usersTable.dataSource = usersTableDataSource
        
        usersTable.addRefreshController(self, action: "searchUsersx")
        searchUsers()

   }
    
    func searchUsersx() {
        print("oi")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.titleView = languageTitleView;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let selectedIndex = usersTable.indexPathForSelectedRow

        if (segue.identifier == "UserDetailsSegue" && selectedIndex != nil) {
            let destVC = segue.destinationViewController as! UserDetailsController
            destVC.user = usersTableDataSource.dataForIndexPath(selectedIndex!) as? User
        }
    }
    
    func searchUsers(reset: Bool = false) {
        userSearchOptions.locationType = selectedLocationType
        userSearchOptions.location = locationNameTextField.text!
        
        usersTableDataSource.searchUsers(reset)
    }
}

extension LanguageRankingsController : UITableViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
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
        
        searchUsers()
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