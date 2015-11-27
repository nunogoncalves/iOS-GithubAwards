//
//  LanguagesController.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 25/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class LanguagesController: UIViewController {
    
    @IBOutlet weak var languagesTable: UITableView!
    
    let languages = ["Swift", "Ruby", "JavaScrip", "Shell", "Go", "Java", "PHP", "Pearl", ".NET"]
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToLanguageRankings" {
            let vc = segue.destinationViewController as! LanguageRankingsController
            vc.language = languages[languagesTable.indexPathForSelectedRow!.row]
        }
    }
}

extension LanguagesController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LanguageCell", forIndexPath: indexPath)
        cell.textLabel?.text = languages[indexPath.row]
        return cell
    }
    
}
