//
//  RepositoryOptionsController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 18/02/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

struct RepositoryOptionsBuilder {
    
    static func build(_ url: String, shareAction: @escaping () -> () = {}) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let browser = actionWith("View on Github", andHandler: viewOnGithub(url))
        let copy = actionWith("Copy URL", andHandler: copyToBoard(url))
        let share = actionWith("Share", andHandler: { _ in shareAction() })
        
        alert.addAction(browser)
        alert.addAction(copy)
        alert.addAction(share)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        return alert
    }
    
    private static func actionWith(_ title: String, andHandler handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default, handler: handler)
    }
    
    private static func viewOnGithub(_ url: String) -> ((UIAlertAction) -> Void)?{
        return { _ in
            Browser.openPage(url)
        }
    }
    
    private static func copyToBoard(_ url: String) -> ((UIAlertAction) -> Void)? {
        return { _ in
            UIPasteboard.general.string = url
        }
    }
}
