//
//  UINib.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 14/05/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

extension UINib {
    
    convenience init(nibName: String) {
        self.init(nibName: nibName, bundle: nil)
    }
    
}
