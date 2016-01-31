//
//  TrendingRepositoryCell.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 31/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class TrendingRepositoryCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var languageImageView: UIImageView!
    @IBOutlet weak var languageStarsSinceLabel: UILabel!
    
    var repositorySince: (repository: Repository, since: String)! {
        didSet {
            let repository = repositorySince.repository
            let since = repositorySince.since
            nameLabel.text = repository.name
            descriptionLabel.text = repository.description
            if let language = repository.language {
                languageStarsSinceLabel.text = "• \(language ?? "") • \(repository.stars) ★ \(since)"
                guard let image = UIImage(named: language.lowercaseString) else { return }
                languageImageView.image = image
            } else {
                languageStarsSinceLabel.text = "• \(repository.stars) ★ \(since)"
                languageImageView.image = UIImage(named: "Language")
            }
        }
    }
}

extension TrendingRepositoryCell : NibReusable {
    
}
