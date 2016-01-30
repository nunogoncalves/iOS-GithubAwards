//
//  TrendingController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 29/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit
import Kanna

class TrendingController : UIViewController {

    @IBOutlet weak var repositoriesTable: UITableView!
    
    var repositories: [String] = []
    
    override func viewDidLoad() {
        do {
            let html = try getHtml() as String
            if let doc = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding) {
                print(doc)
                for repo in doc.xpath("//*[contains(@class, 'repo-list-item')]") {
//                    print(repo.text)
                    let user = repo.css("span").innerHTML!
//                    print(user)
//                    print(repo.css("span").toHTML)
                    
                    var aText = repo.css("a")[1].text!
//                    print(aText)
                    aText = aText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    aText = aText.stringByReplacingOccurrencesOfString(" ", withString: "")
                    aText = aText.stringByReplacingOccurrencesOfString("\n", withString: "")

//                    print(aText)
                    repositories.append(aText)
                    
//                    print("========================================")
//                    print("========================================")
//                    print("========================================")
                }
                repositoriesTable.reloadData()
                // Search for nodes by CSS
//                for link in doc.css("a, link") {
//                    println(link.text)
//                    println(link["href"])
//                }
//                
//                // Search for nodes by XPath
//                for link in doc.xpath("//a | //link") {
//                    println(link.text)
//                    println(link["href"])
//                }
            }
            
//            print(html)
        } catch {
          print("error")
        }
    }
    
    private func getHtml() throws -> NSString {
        let url = "https://github.com/trending?since=weekly"
        return try NSString(contentsOfURL: NSURL(string: url)!, encoding: NSUTF8StringEncoding)
    }
}

extension TrendingController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrendingRepository", forIndexPath: indexPath)
        cell.textLabel!.text = repositories[indexPath.row]
        print(repositories[indexPath.row])
        return cell
    }
    
}
