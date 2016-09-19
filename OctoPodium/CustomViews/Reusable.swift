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
        return String(describing: self)
    }
    
}
public extension NibReusable {
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self))
    }

}

public extension UITableView {
    
    func registerReusableCell<T: UITableViewCell>(_ cellType: T.Type) where T: NibReusable {
        register(T.nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCellFor<T: UITableViewCell>(_ indexPath: IndexPath) -> T where T: Reusable {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
