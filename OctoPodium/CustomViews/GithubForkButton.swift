//
//  GithubForkButton.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 14/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class GithubForkButton : GithubButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitlesAndImages()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitlesAndImages()
    }
    
    private func setTitlesAndImages() {
        setName("Forks")
        setImage(UIImage(named: "ForkDark")!)
    }
    
    func setNumberOfForks(forks: String) {
        setValue(forks)
    }
}
