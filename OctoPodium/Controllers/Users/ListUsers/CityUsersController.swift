//
//  CityUsersController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 07/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class CityUsersController : UsersController {
    
    @IBOutlet weak var pageContainer: UIView! {
        didSet { paginationContainer = pageContainer }
    }
    
    @IBOutlet weak var table: UsersTable! {
        didSet { usersTable = table }
    }
    
    @IBOutlet weak var paginatorLabel: UILabel! {
        didSet { paginationLabel = paginatorLabel }
    }
    
    @IBOutlet weak var githubLoadingIndicator: GithubLoadingView! {
        didSet { loadingView = githubLoadingIndicator }
    }

    @IBOutlet weak var emptyMessageLabel: UILabel! {
        didSet { emptyMessageLabl = emptyMessageLabel }
    }
    
    @IBOutlet weak var noResultsLabel: UILabel! {
        didSet { noResultsLabl = noResultsLabel }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedLocationType = .city
    }
    
    override func sendSearchedLocationToAnalytics() {
        Analytics.SendToGoogle.citySearched(locationName, forLanguage: language)
    }
    
    override func sendUserPaginatedToAnalytics(_ page: String) {
        Analytics.SendToGoogle.usersPaginatedInCity(locationName, forLanguage: language, andPage: page)
    }
}
