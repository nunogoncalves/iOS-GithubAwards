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
    
    var loadingView: GithubLoadingView!
    var refreshControl: UIRefreshControl!
    
    var isAnimating = false
    var timer: NSTimer?
    var loadingDuration: NSTimeInterval = 4.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTable.delegate = self
        usersTable.dataSource = self
        
        setUpRefreshControl()
        addRefreshControl()
        
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
    
    func searchUsers() {
        userSearchOptions.locationType = selectedLocationType
        userSearchOptions.location = locationNameTextField.text!
        
        userSearcher.fetch(success: { [weak self] users in
            self?.users = users
            self?.usersTable.reloadData()
            self?.endOfWork()
            }, failure: { [weak self] in
                self?.endOfWork()
                let alert = UIAlertController(title: "Error", message: "Error loading users", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
//                self?.presentViewController(alert, animated: true, completion: nil)
                
                
                let window = UIApplication.sharedApplication().keyWindow!
                let v = UIView(frame: CGRectMake(0, -100, window.frame.width, 100))
//                v.alpha = 0.5
                v.backgroundColor = UIColor.redColor()
                
                let bounds = v.frame
                let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
                visualEffectView.frame = bounds
                visualEffectView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
                
                window.addSubview(v)
                window.addSubview(visualEffectView)
                
                UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: [], animations: {
                        v.frame = CGRectOffset(v.frame, 0, 64)
                    }, completion: nil)
                
                self?.performSelector("bla:", withObject: v, afterDelay: 2.0)
            })
    }
    
    func bla(v: UIView) {
//    func bla() {
        print("bla")
        UIView.animateWithDuration(0.3, animations: {
            v.frame = CGRectOffset(v.frame, 0, -64)
            }, completion: { _ in
                v.removeFromSuperview()
        })
    }
    
    private func setUpRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.clearColor()
        
        refreshControl.addTarget(self, action: "searchUsers", forControlEvents:.ValueChanged)
        
        addLoadingView()
    }
    
    private func addLoadingView() {
        loadingView = GithubLoadingView(frame: refreshControl.bounds)
        refreshControl.addSubview(loadingView.view)
    }
    
    private func addRefreshControl() {
        usersTable.addSubview(refreshControl)
        usersTable.layoutIfNeeded()
    }
}

extension LanguageRankingsController : UITableViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if refreshControl.refreshing {
            loadingView.setLoading()
        } else {
            let y = scrollView.contentOffset.y
            let perc = y * 100 / 220
            loadingView.setStaticWith(Int(abs(perc)), offset: y)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if refreshControl.refreshing {
            if !isAnimating {
                setUpTimer()
            }
        }
    }
    
    func setUpTimer() {
//        timer = NSTimer.scheduledTimerWithTimeInterval(
//            loadingDuration,
//            target: self,
//            selector: "endOfWork",
//            userInfo: nil,
//            repeats: true)
    }
    
    
    func endOfWork() {
        refreshControl.endRefreshing()
        
        timer?.invalidate()
        timer = nil
    }
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