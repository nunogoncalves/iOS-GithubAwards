//
//  CountryUsersController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 07/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class CountryUsersController : UsersController {
    
    init(language: String, name: String = "", topInset: CGFloat) {
        super.init(language: language, locationType: .country(name: name))
        usersTable.contentInset = UIEdgeInsets(top: 83, left: 0, bottom: 0, right: 0)
        startSearchingLabel.text = "Search for a country"
        setStartSearching()
    }

    override func sendSearchedLocationToAnalytics() {
        Analytics.SendToGoogle.countrySearched(locationName, forLanguage: language)
    }
    
    override func sendUserPaginatedToAnalytics(_ page: String) {
        Analytics.SendToGoogle.usersPaginatedInCountry(locationName, forLanguage: language, andPage: page)
    }
}
