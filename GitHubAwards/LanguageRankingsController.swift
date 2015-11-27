//
//  ViewController.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class LanguageRankingsController: UIViewController {

    @IBOutlet weak var usersTable: UITableView!
    
    var users = [
        User(login: "nunogoncalves", avatarUrl: "https://avatars.githubusercontent.com/u/3007012?v=3"),
        User(login: "vetras", avatarUrl: "https://avatars0.githubusercontent.com/u/2528664?v=3&s=460")
    ]

    var selectedIndex = -1
    
    var city = "Lisbon"
    var language = "JavaScript" {
        didSet {
            navigationItem.title = language
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTable.delegate = self
        usersTable.dataSource = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let selectedIndex = usersTable.indexPathForSelectedRow?.row

        if (segue.identifier == "UserDetailsSegue" && selectedIndex != nil) {
            let destVC = segue.destinationViewController as! UserDetailsController
            destVC.user = users[selectedIndex!]
        }
    }
}

extension LanguageRankingsController : UITableViewDelegate {
    
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