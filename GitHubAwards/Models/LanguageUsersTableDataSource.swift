//
//  LanguageUsersTableDataSource.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 05/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class LanguageUsersTableDataSource : NSObject, TableViewDataSource {
    
    var book: Book
    var searchOptions: SearchOptions
    
    var userSearcher: GetUsers
    var latestUserResponse: UsersListResponse!
    
    var isSearching = false
    
    weak var tableStateListener: TableStateListener?
    
    init(searchOptions: SearchOptions) {
        self.searchOptions = searchOptions
        book = UsersListResponse(users: [], paginator: Paginator())
        userSearcher = GetUsers.init(searchOptions: searchOptions)
    }
    
    func dataForIndexPath(indexPath: NSIndexPath) -> AnyObject {
        return book.data[indexPath.row]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return book.data.count
    }
    
    func cellIdentifierForIndex(indexPath: NSIndexPath) -> String {
        return indexPath.row < 3 ? "TopUserCell" : "UserCell"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row < 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierForIndex(indexPath), forIndexPath: indexPath) as! UserTopCell
            let user = dataForIndexPath(indexPath) as! User
            cell.userPresenter = UserPresenter(user: user, ranking: indexPath.row + 1)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierForIndex(indexPath), forIndexPath: indexPath) as! UserCell
            cell.position = indexPath.row + 1
            cell.user = dataForIndexPath(indexPath) as! User
            return cell
        }
    }
    
    func searchUsers(reset: Bool = false) {
        if isSearching {
            return
        }

        if reset {
            searchOptions.page = 1
            reallyFetchUsers()
            return
        }
        
        if latestUserResponse != nil {
            if latestUserResponse!.hasMoreUsers() {
                searchOptions.page += 1
                reallyFetchUsers()
            }
        } else {
            reallyFetchUsers()
        }
    }
    
    private func reallyFetchUsers() {
        isSearching = true
        userSearcher.fetch(success: usersSuccess, failure: failure)
    }
    
    func usersSuccess(usersResponse: UsersListResponse) {
        book = usersResponse
        isSearching = false
        latestUserResponse = usersResponse
        if usersResponse.isFirstPage() {
            book.data = usersResponse.users
        } else {
            book.data.appendContentsOf(usersResponse.users as [AnyObject])
        }
        tableStateListener?.newDataArrived(usersResponse.paginator)
    }
    
    func failure() {
        tableStateListener?.failedToGetData()
    }
    
    func hasMoreDataAvailable() -> Bool {
        return book.hasMorePages()
    }
    
}
