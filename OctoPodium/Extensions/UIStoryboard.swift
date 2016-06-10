//
//  UIStoryboard.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 10/06/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

extension UIStoryboard {
    
    enum Storyboard : String {
        case Main
    }
    
    convenience init(storyboard: Storyboard, bundle: NSBundle? = nil) {
        self.init(name: storyboard.rawValue)
    }
    
    convenience init(name: String) {
        self.init(name: name, bundle: nil)
    }
    
    class func storyboard(storyboard: Storyboard, bundle: NSBundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
    }
    
    func controller(controller: UIViewController.Type) -> UIViewController {
        return viewControllerWith(id: String(controller))
    }
    
    func viewControllerWith(id id: String) -> UIViewController {
        return instantiateViewControllerWithIdentifier(id) as UIViewController
    }
    
}
