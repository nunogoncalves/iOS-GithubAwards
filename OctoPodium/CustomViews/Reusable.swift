//
//  ReusableNib.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 31/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

public protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

public protocol NibReusable: Reusable {
    static var nib: UINib { get }
}

public extension Reusable {
    
    static var reuseIdentifier: String {
        return String(Self)
    }
    
}
public extension NibReusable {
    
    static var nib: UINib {
        return UINib(nibName: String(Self))
    }

}

public extension UITableView {
    
    func registerReusableCell<T: UITableViewCell where T: NibReusable>(_ cellType: T.Type) {
        registerNib(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCellFor<T: UITableViewCell where T: Reusable>(_ indexPath: NSIndexPath) -> T {
        return dequeueReusableCellWithIdentifier(T.reuseIdentifier, forIndexPath: indexPath) as! T
    }
}
