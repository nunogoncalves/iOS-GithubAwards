//
//  ViewController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class LanguageRankingsController: UIViewController {

    private let languageTitleView = LanguageTitleView(frame: CGRect(x: 0.0, y: 0.0, width: 120.0, height: 40.0))

    private let stackView: UIStackView = create {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }

    private let locationSegmentContainer: UIView = create {
        $0.backgroundColor = .white
        UIView.set($0.heightAnchor, .locationTypeSelectorHeight)
    }

    private var previousSelectedSegmentIndex = 0

    private let locationSegment: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["World", "Country", "City"]).usingAutoLayout()
        segmentControl.tintColor = UIColor(hex: 0x2F9DE6)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(locationTypeChanged), for: .valueChanged)
        return segmentControl
    }()

    private let searchContainer: UIView = create {
        $0.backgroundColor = .white
        $0.isHidden = true
    }

    private let searchBar: SearchBar = create {
        UIView.set($0.heightAnchor, .searchBarHeight)
        $0.barTintColor = UIColor(hex: 0xF3F3F3)
        $0.placeholder = "Filter"
        $0.tintColor = UIColor(hex: 0x909095)
    }

    private let worldContainer: UIView = create {
        $0.backgroundColor = .clear
    }
    private let countryContainer: UIView = create {
        $0.backgroundColor = .clear
        $0.isHidden = true
    }
    private let cityContainer: UIView = create {
        $0.backgroundColor = .clear
        $0.isHidden = true
    }

    lazy var listContainers: [UIView] = {
        return [self.worldContainer, self.countryContainer, self.cityContainer]
    }()

    private let worldController: WorldUsersController
    private let countryController: CountryUsersController
    private let cityController: CityUsersController

    private let language: String
    private var lastCitySearched = ""
    private var lastCountrySearched = ""

    private var locationTypes: [Int: LocationType] = [
        0 : .world,
        1 : .country(name: ""),
        2 : .city(name: "")
    ]
    private var selectedLocationType = LocationType.world

    init(language: Language, locationType: LocationType = .world) {

        self.language = language
        worldController = .init(language: language, topInset: .locationTypeSelectorHeight)
        countryController = .init(language: language, name: locationType.nameOrEmpty, topInset: .searchLocationHeight)
        cityController = .init(language: language, name: locationType.nameOrEmpty, topInset: .searchLocationHeight)

        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .white
        view.addSubview(countryContainer)
        view.addSubview(cityContainer)
        view.addSubview(worldContainer)
        view.addSubview(stackView)
        stackView.addArrangedSubview(locationSegmentContainer)
        stackView.addArrangedSubview(searchContainer)
        locationSegmentContainer.addSubview(locationSegment)
        searchContainer.addSubview(searchBar)

        addChild(countryController)
        countryController.view.usingAutoLayout()
        countryContainer.addSubview(countryController.view)
        countryController.view.pinToBounds(of: countryContainer)
        countryController.didMove(toParent: self)

        addChild(worldController)
        worldContainer.addSubview(worldController.view)
        worldController.view.pinToBounds(of: worldContainer)
        worldController.view.usingAutoLayout()
        worldController.didMove(toParent: self)

        addChild(cityController)
        cityContainer.addSubview(cityController.view)
        cityController.view.usingAutoLayout()
        cityController.view.pinToBounds(of: cityContainer)
        cityController.didMove(toParent: self)

        stackView.constrain(referringTo: view.safeAreaLayoutGuide, bottom: nil)
        locationSegment.centerX(==, locationSegmentContainer)
        locationSegment.centerY(==, locationSegmentContainer)
        locationSegment.leading(==, locationSegmentContainer, 20)
        locationSegment.trailing(==, locationSegmentContainer, -20)

        searchBar.pinToBounds(of: searchContainer)

        worldContainer.pinToBounds(of: view)
        countryContainer.pinToBounds(of: view)
        cityContainer.pinToBounds(of: view)

        title = language
        languageTitleView.render(with: language)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func locationTypeChanged(_ locationTypeControl: UISegmentedControl) {
        let selectedIndex = locationTypeControl.selectedSegmentIndex

        locationTypes[previousSelectedSegmentIndex] = selectedLocationType.with(name: searchBar.text ?? "")

        selectedLocationType = locationTypes[selectedIndex]!

        for listView in listContainers { listView.hide() }
        listContainers[selectedIndex].show()

        setSearchBarText(basedOn: selectedLocationType)
        animateLocationTypeChanged(selectedLocationType.hasName)

        previousSelectedSegmentIndex = selectedIndex
    }

    private func setSearchBarText(basedOn locationType: LocationType) {

        searchBar.text = locationType.nameOrEmpty

        if locationType.hasName {
            searchBar.placeholder = "Insert a \(locationType.type)"
        }
    }

    private func animateLocationTypeChanged(_ showSearchBar: Bool) {
        self.searchContainer.isHidden = !showSearchBar
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchDelegate = self
        Analytics.SendToGoogle.enteredScreen(kAnalytics.rankingScreen(for: language))
        navigationItem.titleView = languageTitleView
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

        switch selectedLocationType {
        case let .country(name):
            if lastCountrySearched == name { break }
            lastCountrySearched = name
            countryController.search(searchBar.text!)
        case let .city(name):
            if lastCitySearched == name { break }
            lastCitySearched = name
            cityController.search(searchBar.text!)
        case .world: break
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        selectedLocationType = selectedLocationType.with(name: searchBar.text!)
    }
}

//class LanguageRankingsController: UIViewController {
//
//    @IBOutlet weak var searchContainer: UIView!
//
//    @IBOutlet weak var locationSegment: UISegmentedControl!
//
//    @IBOutlet weak var worldContainer: UIView!
//    @IBOutlet weak var countryContainer: UIView!
//    @IBOutlet weak var cityContainer: UIView!
//
//    lazy var listContainers: [UIView] = {
//        return [self.worldContainer, self.countryContainer, self.cityContainer]
//    }()
//
//    @IBOutlet weak var searchBar: SearchBar!
//    @IBOutlet weak var loadingIndicator: GithubLoadingView!
//
//    fileprivate var worldController: WorldUsersController!
//    fileprivate var countryController: CountryUsersController!
//    fileprivate var cityController: CityUsersController!
//
//    lazy var listControllers: [UsersController] = { [unowned self] in
//        return [self.worldController, self.countryController, self.cityController]
//    }()
//
//    fileprivate var city = ""
//    fileprivate var lastCitySearched = ""
//    fileprivate var country = ""
//    fileprivate var lastCountrySearched = ""
//
//    let locationTypes: [Int : LocationType] = [0 : .world, 1 : .country, 2 : .city]
//    var selectedLocationType = LocationType.world
//
//    @IBAction func locationTypeChanged(_ locationTypeControl: UISegmentedControl) {
//        let selectedIndex = locationTypeControl.selectedSegmentIndex
//        selectedLocationType = locationTypes[selectedIndex]!
//
//        for listView in listContainers { listView.hide() }
//        listContainers[selectedIndex].show()
//
//        setSearchBarText(basedOn: selectedLocationType)
//        animateLocationTypeChanged(selectedLocationType.hasName)
//    }
//
//    private func setSearchBarText(basedOn locationType: LocationType) {
//
//        switch locationType {
//        case .country:
//            searchBar.text = country
//        case .city:
//            searchBar.text = city
//        case .world: break
//        }
//
//        if locationType.hasName {
//            searchBar.placeholder = "Insert a \(locationType.rawValue)"
//        }
//    }
//
//    private func animateLocationTypeChanged(_ showSearchBar: Bool) {
//        UIView.animate(withDuration: 0.5) { [weak self] in
//            self?.view.layoutIfNeeded()
//            self?.searchContainer.alpha = showSearchBar ? 1.0 : 0.0
//        }
//    }
//
//    let languageTitleView = LanguageTitleView(frame: CGRect(x: 0.0, y: 0.0, width: 120.0, height: 40.0))
//
//    var language: String? {
//        didSet {
//            let lang = language ?? ""
//            navigationItem.title = lang
//            languageTitleView.render(with: lang)
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        searchBar.searchDelegate = self
//        Analytics.SendToGoogle.enteredScreen(kAnalytics.rankingScreen(for: language ?? "?"))
//        navigationItem.titleView = languageTitleView;
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch segue.identifier ?? "" {
//        case kSegues.worldUsersSegue:
//            worldController = segue.worldController
//            worldController.language = language!
//            worldController.navigationControl = navigationController
//        case kSegues.countryUsersSegue:
//            countryController = segue.countryController
//            countryController.navigationControl = navigationController
//        case kSegues.cityUsersSegue:
//            cityController = segue.cityController
//            cityController.navigationControl = navigationController
//        default: break
//        }
//    }
//
//    func selectedCell() -> UITableViewCell {
//        switch selectedLocationType {
//        case .world: return worldController.selectedCell()
//        case .country: return countryController.selectedCell()
//        case .city: return cityController.selectedCell()
//        }
//    }
//}
//
//extension LanguageRankingsController : UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        for controller in listControllers { controller.language = language! }
//
//        switch selectedLocationType {
//        case .country:
//            if country == lastCountrySearched { break }
//            lastCountrySearched = country
//            countryController.search(searchBar.text!)
//        case .city:
//            if city == lastCitySearched { break }
//            lastCitySearched = city
//            cityController.search(searchBar.text!)
//        case .world: break
//        }
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        switch selectedLocationType {
//        case .country:
//            country = searchBar.text!
//        case .city:
//            city = searchBar.text!
//        case .world: break
//        }
//    }
//}
//
//private extension UIStoryboardSegue {
//
//    var countryController: CountryUsersController {
//        return destination as! CountryUsersController
//    }
//
//    var cityController: CityUsersController {
//        return destination as! CityUsersController
//    }
//
//    var worldController: WorldUsersController {
//        return destination as! WorldUsersController
//    }
//
//}

private extension CGFloat {
    static let searchBarHeight: CGFloat = 44
    static let locationTypeSelectorHeight: CGFloat = 40
    static let searchLocationHeight = .searchBarHeight + locationTypeSelectorHeight
}
