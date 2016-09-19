//
//  LanguageUsersTableDataSource.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 05/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class LanguageUsersTableDataSource : NSObject, TableViewDataSource {
    
    var book: Book
    var searchOptions: SearchOptions
    
    var userSearcher: Users.GetList
    var latestUserResponse: UsersListResponse!
    
    var isSearching = false
    
    weak var tableStateListener: TableStateListener?
    
    init(searchOptions: SearchOptions) {
        self.searchOptions = searchOptions
        book = UsersListResponse(users: [], paginator: Paginator())
        userSearcher = Users.GetList(searchOptions: searchOptions)
    }
    
    func dataForIndexPath(_ indexPath: IndexPath) -> AnyObject {
        return book.data[(indexPath as NSIndexPath).row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return book.data.count
    }
    
    func cellIdentifierForIndex(_ indexPath: IndexPath) -> String {
        return (indexPath as NSIndexPath).row < 3 ? String(describing: type(of: UserTopCell.self)) : String(describing: type(of: UserCell.self))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).row < 3 {
            let cell = tableView.dequeueReusableCellFor(indexPath) as UserTopCell
            let user = dataForIndexPath(indexPath) as! User
            cell.userPresenter = UserPresenter(user: user, ranking: indexPath.row + 1)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellFor(indexPath) as UserCell
            cell.position = indexPath.row + 1
            cell.user = dataForIndexPath(indexPath) as! User
            return cell
        }
    }
    
    func searchUsers(_ reset: Bool = false) {
        if isSearching { return }

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
        userSearcher.call(success: usersSuccess, failure: failure)
    }
    
    func usersSuccess(_ usersResponse: UsersListResponse) {
        book.paginator = usersResponse.paginator
        isSearching = false
        latestUserResponse = usersResponse
        if usersResponse.isFirstPage() {
            book.data = usersResponse.users
        } else {
            book.data += (usersResponse.users as [AnyObject])
        }
        tableStateListener?.newDataArrived(usersResponse.paginator)
    }
    
    func failure(_ apiResponse: ApiResponse) {
        tableStateListener?.failedToGetData(apiResponse.status)
    }
    
    func hasMoreDataAvailable() -> Bool {
        return book.hasMorePages()
    }
    
    func getTotalCount() -> Int {
        return book.paginator.totalCount
    }
}
