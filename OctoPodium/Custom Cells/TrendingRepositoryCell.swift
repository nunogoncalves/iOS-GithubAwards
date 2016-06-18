//
//  TrendingRepositoryCell.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 31/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class TrendingRepositoryCell: UITableViewCell, NibReusable {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageImageView: UIImageView!
    @IBOutlet weak var languageStarsSinceLabel: UILabel!
    
    var userClicked: ((userName: String) -> ())?
    
    var repositorySince: (repository: Repository, since: String)! {
        didSet {
            let repository = repositorySince.repository
            let since = repositorySince.since
            
            nameLabel.text = "\(repository.user)/\(repository.name)"

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickedUser))
            nameLabel.isUserInteractionEnabled = true
            nameLabel.addGestureRecognizer(tapGesture)

            descriptionLabel.text = repository.description
            if let language = repository.language {
                languageStarsSinceLabel.text = "• \(language ?? "") • \(repository.stars) ★ \(since)"
                if let image = UIImage(named: language.lowercased()) {
                    languageImageView.image = image
                } else {
                    languageImageView.image = UIImage(named: "Language")
                }
            } else {
                languageStarsSinceLabel.text = "• \(repository.stars) ★ \(since)"
                languageImageView.image = UIImage(named: "Language")
            }
        }
    }
    
    @objc private func clickedUser() {
        userClicked?(userName: repositorySince.repository.user)
    }
}
