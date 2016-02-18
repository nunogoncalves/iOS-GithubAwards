//
//  RepositoryOptionsController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 18/02/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

struct RepositoryOptionsBuilder {
    
    static func build(repository: Repository, shareAction: () -> () = {}) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let browser = UIAlertAction(title: "View on Github", style: .Default, handler: viewOnGithub(repository))
        alert.addAction(browser)
        
        let copy = UIAlertAction(title: "Copy URL", style: .Default, handler: copyToBoard(repository))
        alert.addAction(copy)
        
        alert.addAction(UIAlertAction(title: "Share", style: .Default, handler: {_ in shareAction() }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        
        return alert
    }
    
    private static func viewOnGithub(repository: Repository) -> ((UIAlertAction) -> Void)?{
        return { _ in
            Browser.openPage(repository.url)
        }
    }
    
    private static func copyToBoard(repository: Repository) -> ((UIAlertAction) -> Void)? {
        return { _ in
            UIPasteboard.generalPasteboard().string = repository.url
        }
    }
}
