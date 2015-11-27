//
//  UsersSearchController.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 26/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class UsersSearchController: UIViewController {

    var users = [
        User(login: "nunogoncalves", avatarUrl: "https://avatars.githubusercontent.com/u/3007012?v=3"),
        User(login: "vetras", avatarUrl: "https://avatars0.githubusercontent.com/u/2528664?v=3&s=460")
    ]
    
    @IBOutlet weak var usersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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