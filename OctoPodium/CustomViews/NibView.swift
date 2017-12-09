//
//  NibView.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 14/05/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

protocol NibView {
    
    var view: UIView! { get }
    
    var type: String? { get }
    
    func commonInit()
    func afterCommonInit()

}

extension NibView where Self : UIView {
    
    func commonInit() {
        loadViewFromNib()
        view.frame = bounds
        view.layoutIfNeeded()
        afterCommonInit()
    }
    
    
    private func loadViewFromNib() {
        if let type = type {
            Bundle.main.loadNibNamed(type, owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed(String(describing: Swift.type(of: self)), owner: self, options: nil)
        }
        addSubview(view)
    }
    
}
