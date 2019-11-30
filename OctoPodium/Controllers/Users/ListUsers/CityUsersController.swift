//
//  CityUsersController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 07/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class CityUsersController : UsersController {

    init(language: String, name: String = "", topInset: CGFloat) {
        super.init(language: language, locationType: .city(name: name))
        usersTable.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
        startSearchingLabel.text = "Search for a city"
        setStartSearching()
    }

    override func sendSearchedLocationToAnalytics() {
        Analytics.SendToGoogle.citySearched(locationName, forLanguage: language)
    }
    
    override func sendUserPaginatedToAnalytics(_ page: String) {
        Analytics.SendToGoogle.usersPaginatedInCity(locationName, forLanguage: language, andPage: page)
    }
}
