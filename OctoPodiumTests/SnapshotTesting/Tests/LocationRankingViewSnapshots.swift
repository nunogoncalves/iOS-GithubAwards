//
//  LocationRankingViewSnapshots.swift
//  OctoPodiumTests
//
//  Created by Nuno Gonçalves on 12/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation
@testable import OctoPodium
import FBSnapshotTestCase

struct LocationRanking: LocationRankingProtocol {
    let worldRanking: WorldRanking
    let countryRanking: CountryRanking?
    let cityRanking: CityRanking?
}

final class LocationRankingViewSnapshots: FBSnapshotTestCase {

    private typealias SELF = LocationRankingViewSnapshots

    private static let targetSize = CGSize(width: 320, height: 10)
    private let view = LocationRankingView(frame: CGRect(origin: .zero, size: SELF.targetSize))

    override func setUp() {

        super.setUp()
        folderName = String(describing: type(of: view))
        view.backgroundColor = .white
        view.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        self.recordMode = false
    }

    func testWithAllElements() {
        view.render(
            with: LocationRanking(
                worldRanking: WorldRanking(position: 125, total: 8325),
                countryRanking: CountryRanking(name: "Portugal", position: 23, total: 341),
                cityRanking: CountryRanking(name: "Lisbon", position: 3, total: 45)
            )
        )
        view.frame.size = view.systemLayoutSizeFitting(
            SELF.targetSize,
            withHorizontalFittingPriority: UILayoutPriority.required,
            verticalFittingPriority: .defaultHigh
        )
        FBSnapshotVerifyView(view)
    }

    func testWorldOnly() {
        view.render(
            with: LocationRanking(
                worldRanking: WorldRanking(position: 125, total: 8325),
                countryRanking: nil,
                cityRanking: nil
            )
        )
        view.frame.size = view.systemLayoutSizeFitting(
            SELF.targetSize,
            withHorizontalFittingPriority: UILayoutPriority.required,
            verticalFittingPriority: .defaultHigh
        )
        FBSnapshotVerifyView(view)
    }

    func testCityOnly() {
        view.render(
            with: LocationRanking(
                worldRanking: WorldRanking(position: 125, total: 8325),
                countryRanking: nil,
                cityRanking: CityRanking(name: "Lisbon", position: 3, total: 45)
            )
        )
        view.frame.size = view.systemLayoutSizeFitting(
            SELF.targetSize,
            withHorizontalFittingPriority: UILayoutPriority.required,
            verticalFittingPriority: .defaultHigh
        )

        FBSnapshotVerifyView(view)
    }

    func testCountryOnly() {
        view.render(
            with: LocationRanking(
                worldRanking: WorldRanking(position: 125, total: 8325),
                countryRanking: CountryRanking(name: "Portugal", position: 23, total: 341),
                cityRanking: nil
            )
        )
        view.frame.size = view.systemLayoutSizeFitting(
            SELF.targetSize,
            withHorizontalFittingPriority: UILayoutPriority.required,
            verticalFittingPriority: .defaultHigh
        )
        FBSnapshotVerifyView(view)
    }
}

