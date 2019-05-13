//
//  RankingCell.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

protocol LocationDelegate: class {
    func clickedCity(_ city: String, forLanguage language: String)
    func clickedCountry(_ country: String, forLanguage language: String)
    func clickedWorld(forLanguage language: String)
    func clickedLanguage(_ language: String)
}

extension RankingPresenter: LocationRankingProtocol {}

class RankingCell: UITableViewCell, Reusable {

    weak var locationDelegate: LocationDelegate?
    private var presenter: RankingPresenter?

    private let header: RankingCellHeader = create {
        $0.heightAnchor.constraint(equalToConstant: 38).isActive = true
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
        rankingsStackView.constrain(referringTo: contentView, top: 5, leading: 5, bottom: nil, trailing: -5)
        rankingsStackView.addArrangedSubview(header)
        rankingsStackView.addArrangedSubview(locationsRankingView)
        rankingsStackView.sendSubviewToBack(locationsRankingView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showUserLanguage))
        header.addGestureRecognizer(tapGesture)
    }

    @objc private func showUserLanguage() {
        guard let language = presenter?.language else { return }
        locationDelegate?.clickedLanguage(language)
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

extension RankingPresenter: RankingHeaderModelProtocol {
    var isPodium: Bool {
        return hasMedals
    }

    var numberOfStars: Int {
        return stars
    }

    var numberOfRepos: Int {
        return repositories
    }
}
