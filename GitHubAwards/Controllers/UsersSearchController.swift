//
//  UsersSearchController.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 26/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class UsersSearchController: UIViewController {

    var users: [User] = []
    
    @IBOutlet weak var usersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchOptions = SearchOptions()
        searchOptions.language = "swift"
        searchOptions.location = "Lisbon"
        searchOptions.locationType = .City
        GetUsers(searchOptions: searchOptions).fetch(success: { [weak self] usersResult in
            self?.users = usersResult
            self?.usersTable.reloadData()
            }, failure: { [weak self] in
                let alert = UIAlertController(title: "Error", message: "Error loading users", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
                self?.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "UsersSearchToDetailSegue" {
            let vc = segue.destinationViewController as! UserDetailsController
            vc.user = users[usersTable.indexPathForSelectedRow!.row]
        }
    }
}

extension UsersSearchController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }

}