//
//  UIStoryboard.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 10/06/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

extension UIStoryboard {
    
    enum Storyboard : String {
        case main = "Main"
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
    
    func controller<T: UIViewController>(_ controller: T.Type) -> T {
        print(String(describing: controller))
        return instantiateViewController(withIdentifier: String(describing: controller)) as! T
    }
    
    func controller<T: UIViewController>(with id: String) -> T {
        return instantiateViewController(withIdentifier: id) as! T
    }
}
