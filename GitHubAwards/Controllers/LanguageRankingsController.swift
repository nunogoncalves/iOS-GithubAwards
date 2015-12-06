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
        searchUsers()
    }

    @IBOutlet weak var locationNameTextField: UITextField!
    
    let locationTypes: [Int : LocationType] = [0 : .City, 1 : .Country, 2 : .World]
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
    
    var loadingView: GithubLoadingView!
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTable.delegate = self
        usersTableDataSource = LanguageUsersTableDataSource(searchOptions: userSearchOptions)
        usersTableDataSource.tableStateListener = self
        usersTable.dataSource = usersTableDataSource
        
        setUpRefreshControl()

        searchUsers()
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
    
    func searchUsers() {
        userSearchOptions.locationType = selectedLocationType
        userSearchOptions.location = locationNameTextField.text!
        
        usersTableDataSource.searchUsers()
    }
    
    private func setUpRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.clearColor()
        
        refreshControl.addTarget(self, action: "searchUsers", forControlEvents:.ValueChanged)
        
        addLoadingViewToRefreshControl()
        addRefreshControl()
    }
    
    private func addLoadingViewToRefreshControl() {
        loadingView = GithubLoadingView(frame: refreshControl.bounds)
        refreshControl.addSubview(loadingView.view)
    }
    
    private func addRefreshControl() {
        usersTable.addSubview(refreshControl)
        usersTable.layoutIfNeeded()
    }
}

extension LanguageRankingsController : UITableViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchUsersIfTableReady()
        updateRefreshControl()
    }
    
    func searchUsersIfTableReady() {
        if !usersTable.isFooterVisible() {
            return
        }
        
        searchUsers()
    }
    
    private func updateRefreshControl() {
        if refreshControl.refreshing {
            loadingView.setLoading()
        } else {
            let y = usersTable.contentOffset.y
            let perc = y * 100 / 220
            loadingView.setStaticWith(Int(abs(perc)), offset: y)
        }
    }
    
    func stopLoadingIndicator() {
        refreshControl.endRefreshing()
    }
}

extension LanguageRankingsController : TableStateListener {
    func newDataArrived(paginator: Paginator) {
        if paginator.isLastPage() {
            usersTable.hideFooter()
        } else {
            usersTable.showFooter()
        }
        usersTable.reloadData()
        stopLoadingIndicator()
    }
    
    func failedToGetData() {
        stopLoadingIndicator()
        NotifyError.display()
    }
}