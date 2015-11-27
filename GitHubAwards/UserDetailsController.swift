//
//  UserDetailsController.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class UserDetailsController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var rankingsTable: UITableView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var rankings = [Ranking]()
    
    var user: User? {
        didSet {
            rankings = user?.rankings ?? []
        }
    }
    
    override func viewDidLoad() {
        nameLabel.text = user!.login
        if let avatarUrl = user!.avatarUrl {
            ImageLoader.fetchAndLoad(avatarUrl, imageView: avatarImageView) {
                self.loading.stopAnimating()
            }
        }
    }
}

extension UserDetailsController: UITableViewDelegate {
    
}

extension UserDetailsController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RankingCell", forIndexPath: indexPath) as! RankingCell
        cell.ranking = rankings[indexPath.row]
        return cell
    }
}
