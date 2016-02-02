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
    
    @IBAction func buttonClick() {
        print("button click")
    }
    
    var userClicked: ((userName: String) -> ())?
    
    var repositorySince: (repository: Repository, since: String)! {
        didSet {
            let repository = repositorySince.repository
            let since = repositorySince.since
            
//            let userStr = getAttributedUser(repository.user)
//            let repoName = NSMutableAttributedString(string: repository.name)
//            
//            userStr.appendAttributedString(repoName)
            
            nameLabel.text = "\(repository.user)\(repository.name)"
//            nameLabel.attributedText = userStr

            let tapGesture = UITapGestureRecognizer(target: self, action: "clickedUser")
            nameLabel.userInteractionEnabled = true
            nameLabel.addGestureRecognizer(tapGesture)

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
    
    private func getAttributedUser(user: String) -> NSMutableAttributedString {
        let attributes = [
            NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue,
        ]
        
        return NSMutableAttributedString(string: user, attributes: attributes)
    }
    
    @objc private func clickedUser() {
        userClicked?(userName: repositorySince.repository.user)
    }
}
