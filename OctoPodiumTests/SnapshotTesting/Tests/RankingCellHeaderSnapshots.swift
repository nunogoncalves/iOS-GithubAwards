//
//  RankingCellHeaderSnapshotTests.swift
//  OctoPodiumTests
//
//  Created by Nuno Gonçalves on 10/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation
@testable import OctoPodium
import FBSnapshotTestCase

struct HeaderModel: RankingHeaderModelProtocol {
    var isPodium: Bool
    var language: String
    var numberOfStars: Int
    var numberOfRepos: Int
    var medals: Medals
}

final class RankingCellHeaderSnapshots: FBSnapshotTestCase {

    let model = HeaderModel(isPodium: true, language: "Swift", numberOfStars: 15352, numberOfRepos: 53, medals: .gold)
    let model1 = HeaderModel(isPodium: true, language: "Javascript", numberOfStars: 243, numberOfRepos: 23, medals: [.gold, .silver])
    let model2 = HeaderModel(isPodium: true, language: "Ruby", numberOfStars: 24, numberOfRepos: 5, medals: .all)

    func buildHeader(origin: CGPoint) -> RankingCellHeader {
        return RankingCellHeader(frame: CGRect(origin: origin, size: CGSize(width: 300, height: 40)))
    }

    override func setUp() {

        super.setUp()
        folderName = String(describing: RankingCellHeader.self)

        self.recordMode = false
    }

    func testPodiumStyle() {

        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 140)))

        let header = buildHeader(origin: .zero)

        header.render(with: model)
        view.addSubview(header)

        let header2 = buildHeader(origin: CGPoint(x: 0, y: 50))
        header2.render(with: model1)
        view.addSubview(header2)

        let header3 = buildHeader(origin: CGPoint(x: 0, y: 100))
        header3.render(with: model2)
        view.addSubview(header3)

        FBSnapshotVerifyView(view)
    }

    func testRegularStyle() {

        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 140)))

        let header = buildHeader(origin: .zero)
        var _model = model
        _model.medals = []
        _model.isPodium = false
        header.render(with: _model)
        view.addSubview(header)

        let header2 = buildHeader(origin: CGPoint(x: 0, y: 50))
        var _model1 = model1
        _model1.medals = []
        _model1.isPodium = false
        header2.render(with: _model1)
        view.addSubview(header2)

        let header3 = buildHeader(origin: CGPoint(x: 0, y: 100))
        var _model2 = model2
        _model2.medals = []
        _model2.isPodium = false
        header3.render(with: _model2)
        view.addSubview(header3)

        FBSnapshotVerifyView(view)
    }
}
