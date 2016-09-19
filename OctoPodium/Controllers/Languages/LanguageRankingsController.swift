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
    
    lazy var listContainers: [UIView] = { [unowned self] in
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
    
    let locationTypes: [Int : LocationType] = [0 : .World, 1 : .Country, 2 : .City]
    var selectedLocationType = LocationType.World

    @IBAction func locationTypeChanged(_ locationTypeControl: UISegmentedControl) {
        let selectedIndex = locationTypeControl.selectedSegmentIndex
        selectedLocationType = locationTypes[selectedIndex]!
        
        for listView in listContainers { listView.hide() }
        listContainers[selectedIndex].show()
        
        setSearchBarTextBasedOn(selectedLocationType)
        animateLocationTypeChanged(selectedLocationType.hasName())
    }

    private func setSearchBarTextBasedOn(_ locationType: LocationType) {
        switch locationType {
        case .Country:
            searchBar.text = country
        case .City:
            searchBar.text = city
        default: break;
        }
        
        if locationType.hasName() {
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
            languageTitleView.language = lang
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchDelegate = self
        Analytics.SendToGoogle.enteredScreen(kAnalytics.rankingScreenFor(language ?? "?"))
        navigationItem.titleView = languageTitleView;
   }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case kSegues.worldUsersSegue:
            worldController = segue.worldController()
            worldController.language = language!
            worldController.navigationControl = navigationController
        case kSegues.countryUsersSegue:
            countryController = segue.countryController()
            countryController.navigationControl = navigationController
        case kSegues.cityUsersSegue:
            cityController = segue.cityController()
            cityController.navigationControl = navigationController
        default: break
        }
    }
    
    func selectedCell() -> UITableViewCell {
        switch selectedLocationType {
        case .World: return worldController.selectedCell()
        case .Country: return countryController.selectedCell()
        case .City: return cityController.selectedCell()
        }
    }
}

extension LanguageRankingsController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        for controller in listControllers { controller.language = language! }
        
        switch selectedLocationType {
        case .Country:
            if country == lastCountrySearched { break }
            lastCountrySearched = country
            countryController.search(searchBar.text!)
        case .City:
            if city == lastCitySearched { break }
            lastCitySearched = city
            cityController.search(searchBar.text!)
        default: return
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch selectedLocationType {
        case .Country:
            country = searchBar.text!
        case .City:
            city = searchBar.text!
        default: return
        }
    }
}

private extension UIStoryboardSegue {
    func countryController() -> CountryUsersController {
        return destination as! CountryUsersController
    }
    
    func cityController() -> CityUsersController {
        return destination as! CityUsersController
    }
    
    func worldController() -> WorldUsersController {
        return destination as! WorldUsersController
    }
    
}
