//
//  RankingCell.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit
import Xtensions

protocol RankingSelectionDelegate: AnyObject {
    func tappedLanguage(_ language: String)
    func tappedCity(_ city: String, forLanguage: String)
    func tappedCountry(_ country: String, forLanguage: String)
    func tappedWorld(forLanguage: String)
}

extension RankingPresenter: LocationRankingProtocol {}

class RankingCell: UITableViewCell, Reusable {

    weak var delegate: RankingSelectionDelegate?
    private var presenter: RankingPresenter?

    private let header: RankingCellHeader = create {
        $0.constrain(height: 38)
    }

    private let locationsRankingView: LocationRankingView = create {
        //Bottom 12 will compensate -1 spacing on the stackview to make it look like the border only exists left/bottom/right
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 13, bottom: 12, right: 15)
        $0.borderWidth = 1
        $0.borderColor = UIColor(hex: 0xDADADA)
    }

    private let rankingsStackView: UIStackView = create {
        $0.axis = .vertical
        //-1 will compensate bottom 12 spacing on the stackview to make it look like the border only exists left/bottom/right
        $0.spacing = -1
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(rankingsStackView)
        rankingsStackView.constrain(referringTo: contentView, top: 5, leading: 5, bottom: 0, trailing: -5)
        rankingsStackView.addArrangedSubview(header)
        rankingsStackView.addArrangedSubview(locationsRankingView)
        rankingsStackView.sendSubviewToBack(locationsRankingView) //Hide the gray line

        locationsRankingView.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showUserLanguage))
        header.addGestureRecognizer(tapGesture)
    }

    @objc private func showUserLanguage() {
        guard let language = presenter?.language else { return }
        delegate?.tappedLanguage(language)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(with presenter: RankingPresenter) {
        header.render(with: presenter)
        self.presenter = presenter
        locationsRankingView.render(with: presenter)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        header.reset()
    }
}

extension RankingCell: LocationSelectionProtocol {

    func tappedCity(_ city: String) {
        guard let presenter = presenter else { return }
        delegate?.tappedCity(city, forLanguage: presenter.language)
    }

    func tappedCountry(_ country: String) {
        guard let presenter = presenter else { return }
        delegate?.tappedCountry(country, forLanguage: presenter.language)
    }

    func tappedWorld() {
        guard let presenter = presenter else { return }
        delegate?.tappedWorld(forLanguage: presenter.language)
    }
}
