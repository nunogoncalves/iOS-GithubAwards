//
//  GithubStarButton.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 14/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class GithubStarButton : GithubButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitlesAndImages()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitlesAndImages()
    }
    
    private func setTitlesAndImages() {
        setName("Stars")
        setImage(UIImage(named: "StarDark")!)
    }
    
    func setNumberOfStars(stars: String) {
        setValue(stars)
    }

    
}

