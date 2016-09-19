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
    
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue)
    }
    
    convenience init(name: String) {
        self.init(name: name, bundle: nil)
    }
    
    class func storyboard(storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
    }
    
    func controller(controller: UIViewController.Type) -> UIViewController {
        return viewControllerWith(id: String(describing: controller))
    }
    
    func viewControllerWith(id: String) -> UIViewController {
        return instantiateViewController(withIdentifier: id) as UIViewController
    }
    
}
