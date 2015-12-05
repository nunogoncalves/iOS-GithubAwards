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

    var users = [User]()

    var selectedIndex = -1
    
    var language: String? {
        didSet {
            let lang = language ?? ""
            userSearchOptions.language = lang
            languageTitleView.language = lang
        }
    }
    
    let languageTitleView = LanguageTitleView(frame: CGRectMake(0.0, 0.0, 120.0, 40.0))
    
    let userSearchOptions = SearchOptions()
    var userSearcher: GetUsers!
    
    var latestUserResponse: UsersListResponse?
    
    var isSearching = false
    
    var loadingView: GithubLoadingView!
    var refreshControl: UIRefreshControl!
    
    var isAnimating = false
    var loadingDuration: NSTimeInterval = 4.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTable.delegate = self
        usersTable.dataSource = self
        
        setUpRefreshControl()

        userSearcher = GetUsers(searchOptions: userSearchOptions)
        searchUsers()
    }
    
//    http://stackoverflow.com/questions/21429346/ios-splash-screen-animation
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.titleView = languageTitleView;
    }
    
    private func setNavigationTitle() {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let selectedIndex = usersTable.indexPathForSelectedRow?.row

        if (segue.identifier == "UserDetailsSegue" && selectedIndex != nil) {
            let destVC = segue.destinationViewController as! UserDetailsController
            destVC.user = users[selectedIndex!]
        }
    }
    
    func searchUsers() {
        isSearching = true
        userSearchOptions.locationType = selectedLocationType
        userSearchOptions.location = locationNameTextField.text!
        
        userSearcher.fetch(success: { [weak self] usersResponse in
            self?.handleUsersResponseSuccess(usersResponse)
            }, failure: { [weak self] in
                self?.stopLoadingIndicator()
                NotifyError.display()
            })
    }
    
    private func handleUsersResponseSuccess(usersResponse: UsersListResponse) {
        isSearching = false
        latestUserResponse = usersResponse
        print(usersResponse.users.count)
        if usersResponse.isFirstPage() {
            users = usersResponse.users
        } else {
            users.appendContentsOf(usersResponse.users)
        }
        
        if usersResponse.isLastPage() {
            usersTable.hideFooter()
        } else {
            usersTable.showFooter()
        }
        usersTable.reloadData()
        stopLoadingIndicator()
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
        
        if isSearching {
            return
        }
        
        if latestUserResponse!.hasMoreUsers() {
            userSearchOptions.page += 1
            searchUsers()
        }
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

extension LanguageRankingsController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
}