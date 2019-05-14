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
    
    @IBOutlet weak var locationSegment: UISegmentedControl!
    
    @IBOutlet weak var worldContainer: UIView!
    @IBOutlet weak var countryContainer: UIView!
    @IBOutlet weak var cityContainer: UIView!
    
    lazy var listContainers: [UIView] = {
        return [self.worldContainer, self.countryContainer, self.cityContainer]
    }()
    
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet weak var loadingIndicator: GithubLoadingView!
    
    fileprivate var worldController: WorldUsersController!
    fileprivate var countryController: CountryUsersController!
    fileprivate var cityController: CityUsersController!
    
    lazy var listControllers: [UsersController] = { [unowned self] in
        return [self.worldController, self.countryController, self.cityController]
    }()
    
    fileprivate var city = ""
    fileprivate var lastCitySearched = ""
    fileprivate var country = ""
    fileprivate var lastCountrySearched = ""
    
    let locationTypes: [Int : LocationType] = [0 : .world, 1 : .country, 2 : .city]
    var selectedLocationType = LocationType.world

    @IBAction func locationTypeChanged(_ locationTypeControl: UISegmentedControl) {
        let selectedIndex = locationTypeControl.selectedSegmentIndex
        selectedLocationType = locationTypes[selectedIndex]!
        
        for listView in listContainers { listView.hide() }
        listContainers[selectedIndex].show()
        
        setSearchBarText(basedOn: selectedLocationType)
        animateLocationTypeChanged(selectedLocationType.hasName)
    }

    private func setSearchBarText(basedOn locationType: LocationType) {

        switch locationType {
        case .country:
            searchBar.text = country
        case .city:
            searchBar.text = city
        case .world: break
        }
        
        if locationType.hasName {
            searchBar.placeholder = "Insert a \(locationType.rawValue)"
        }
    }
    
    private func animateLocationTypeChanged(_ showSearchBar: Bool) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.view.layoutIfNeeded()
            self?.searchContainer.alpha = showSearchBar ? 1.0 : 0.0
        }
    }
    
    let languageTitleView = LanguageTitleView(frame: CGRect(x: 0.0, y: 0.0, width: 120.0, height: 40.0))
    
    var language: String? {
        didSet {
            let lang = language ?? ""
            navigationItem.title = lang
            languageTitleView.render(with: lang)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchDelegate = self
        Analytics.SendToGoogle.enteredScreen(kAnalytics.rankingScreen(for: language ?? "?"))
        navigationItem.titleView = languageTitleView;
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case kSegues.worldUsersSegue:
            worldController = segue.worldController
            worldController.language = language!
            worldController.navigationControl = navigationController
        case kSegues.countryUsersSegue:
            countryController = segue.countryController
            countryController.navigationControl = navigationController
        case kSegues.cityUsersSegue:
            cityController = segue.cityController
            cityController.navigationControl = navigationController
        default: break
        }
    }
    
    func selectedCell() -> UITableViewCell {
        switch selectedLocationType {
        case .world: return worldController.selectedCell()
        case .country: return countryController.selectedCell()
        case .city: return cityController.selectedCell()
        }
    }
}

extension LanguageRankingsController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        for controller in listControllers { controller.language = language! }
        
        switch selectedLocationType {
        case .country:
            if country == lastCountrySearched { break }
            lastCountrySearched = country
            countryController.search(searchBar.text!)
        case .city:
            if city == lastCitySearched { break }
            lastCitySearched = city
            cityController.search(searchBar.text!)
        case .world: break
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch selectedLocationType {
        case .country:
            country = searchBar.text!
        case .city:
            city = searchBar.text!
        case .world: break
        }
    }
}

private extension UIStoryboardSegue {

    var countryController: CountryUsersController {
        return destination as! CountryUsersController
    }
    
    var cityController: CityUsersController {
        return destination as! CityUsersController
    }
    
    var worldController: WorldUsersController {
        return destination as! WorldUsersController
    }
    
}
