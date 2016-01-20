//
//  ViewController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class LanguageRankingsController: UIViewController {

    @IBOutlet weak var searchContainer: UIView!
    
    @IBOutlet weak var worldContainer: UIView!
    @IBOutlet weak var countryContainer: UIView!
    @IBOutlet weak var cityContainer: UIView!
    
    @IBOutlet weak var searchBar: SearchBar!
    
    @IBOutlet weak var loadingIndicator: GithubLoadingView!
    
    var worldController: WorldUsersController!
    var countryController: CountryUsersController!
    var cityController: CityUsersController!
    
    var city = ""
    var lastCitySearched = ""
    var country = ""
    var lastCountrySearched = ""
    
    @IBAction func locationTypeChanged(locationTypeControl: UISegmentedControl) {
        selectedLocationType = locationTypes[locationTypeControl.selectedSegmentIndex]!
        
        let containers = [worldContainer, countryContainer, cityContainer]
        worldContainer.hide()
        countryContainer.hide()
        cityContainer.hide()
        
        containers[locationTypeControl.selectedSegmentIndex].show()
        
        switch selectedLocationType {
        case .Country:
            searchBar.text = country
        case .City:
            searchBar.text = city
        default: break;
        }
        
        if selectedLocationType.hasName() {
            searchBar.placeholder = "Insert a \(selectedLocationType.rawValue)"
        }
        animateLocationTypeChanged()
    }
    
    private func animateLocationTypeChanged() {
        UIView.animateWithDuration(0.5) { [weak self] in
            self?.view.layoutIfNeeded()
            self?.searchContainer.alpha = self!.selectedLocationType.hasName() ? 1.0 : 0.0
        }
    }
    
    let locationTypes: [Int : LocationType] = [0 : .World, 1 : .Country, 2 : .City]
    var selectedLocationType = LocationType.World

//    let languageTitleView = LanguageTitleView(frame: CGRectMake(0.0, 0.0, 120.0, 40.0))
    
    var language: String? {
        didSet {
            let lang = language ?? ""
            navigationItem.title = lang
//            languageTitleView.language = lang
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchDelegate = self
   }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationItem.titleView = languageTitleView;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier ?? "" {
        case kSegues.worldUsersSegue:
            worldController = segue.worldController()
            worldController.language = language!
        case kSegues.countryUsersSegue:
            countryController = segue.countryController()
        case kSegues.cityUsersSegue:
            cityController = segue.cityController()
        default: break
        }
    }
}

private extension UIStoryboardSegue {
    func countryController() -> CountryUsersController {
        return destinationViewController as! CountryUsersController
    }
    
    func cityController() -> CityUsersController {
        return destinationViewController as! CityUsersController
    }
    
    func worldController() -> WorldUsersController {
        return destinationViewController as! WorldUsersController
    }
    
}

extension LanguageRankingsController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        worldController.language = language!
        countryController.language = language!
        cityController.language = language!
        
        switch selectedLocationType {
        case .Country:
            if country == lastCountrySearched {
                break
            }
            lastCountrySearched = country
            countryController.search(searchBar.text!)
        case .City:
            if city == lastCitySearched {
                break
            }
            lastCitySearched = city
            cityController.search(searchBar.text!)
        default: return
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        switch selectedLocationType {
        case .Country:
            country = searchBar.text!
        case .City:
            city = searchBar.text!
        default: return
        }
    }
    
}
