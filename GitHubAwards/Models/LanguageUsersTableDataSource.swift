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
    
    func cellIdentifierForIndex(indexPath: NSIndexPath) -> String {
        return "UserCell"
    }
    
    func dataForIndexPath(indexPath: NSIndexPath) -> AnyObject {
        return book.data[indexPath.row]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return book.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifierForIndex(indexPath), forIndexPath: indexPath) as! UserCell
        cell.user = dataForIndexPath(indexPath) as! User
        return cell
    }
    
    func searchUsers() {
        if isSearching {
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
    
}
