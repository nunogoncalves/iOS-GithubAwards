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
    @IBOutlet weak var searchContainer: UIView!

    @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
    
    @IBAction func locationTypeChanged(locationTypeControl: UISegmentedControl) {
        selectedLocationType = locationTypes[locationTypeControl.selectedSegmentIndex]!
        tableTopConstraint.constant = selectedLocationType.hasName() ? 50 : 10
        
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
    
    var city = "Lisbon"
    var language = "JavaScript" {
        didSet {
            navigationItem.title = language
        }
    }
    
    let userSearchOptions = SearchOptions()
    var userSearcher: GetUsers!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTable.delegate = self
        usersTable.dataSource = self
        userSearchOptions.language = language
        userSearcher = GetUsers(searchOptions: userSearchOptions)
        searchUsers()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let selectedIndex = usersTable.indexPathForSelectedRow?.row

        if (segue.identifier == "UserDetailsSegue" && selectedIndex != nil) {
            let destVC = segue.destinationViewController as! UserDetailsController
            destVC.user = users[selectedIndex!]
        }
    }
    
    private func searchUsers() {
        userSearchOptions.locationType = selectedLocationType
        userSearchOptions.location = locationNameTextField.text!
        
        userSearcher.fetch(success: { [weak self] users in
            self?.users = users
            self?.usersTable.reloadData()
            }, failure: { [weak self] in
                let alert = UIAlertController(title: "Error", message: "Error loading users", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
                self?.presentViewController(alert, animated: true, completion: nil)
                
                
                let window = UIApplication.sharedApplication().keyWindow!
                let v = UIView(frame: CGRectMake(0, 0, window.frame.width, 64))
                let l = UILabel(frame: CGRectMake(0, 0, window.frame.width, 30))
                l.backgroundColor = UIColor.greenColor()
                l.text = "Eerror bla bla bl2"
                v.alpha = 0.5
                v.backgroundColor = UIColor.redColor()
                
                let bounds = v.frame
                let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
                visualEffectView.frame = bounds
                visualEffectView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
                v.addSubview(visualEffectView)
                v.addSubview(l)
                
                window.addSubview(v)
            })
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