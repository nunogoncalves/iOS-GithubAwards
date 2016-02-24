//
//  RepositoryOptionsController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 18/02/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

struct RepositoryOptionsBuilder {
    
    static func build(url: String, shareAction: () -> () = {}) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let browser = actionWith(title: "View on Github", andHandler: viewOnGithub(url))
        let copy = actionWith(title: "Copy URL", andHandler: copyToBoard(url))
        let share = actionWith(title: "Share", andHandler: { _ in shareAction() })
        
        alert.addAction(browser)
        alert.addAction(copy)
        alert.addAction(share)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        return alert
    }
    
    private static func actionWith(title title: String, andHandler handler: (UIAlertAction -> Void)?) -> UIAlertAction {
        return UIAlertAction(title: title, style: .Default, handler: handler)
    }
    
    private static func viewOnGithub(url: String) -> ((UIAlertAction) -> Void)?{
        return { _ in
            Browser.openPage(url)
        }
    }
    
    private static func copyToBoard(url: String) -> ((UIAlertAction) -> Void)? {
        return { _ in
            UIPasteboard.generalPasteboard().string = url
        }
    }
}
