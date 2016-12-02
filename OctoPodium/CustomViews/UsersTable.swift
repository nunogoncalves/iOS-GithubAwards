//
//  UsersTable.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 07/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

class UsersTable : PaginaTable, NibReusable {
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private let userCellReuseId = "UserCell"
    private let userTopCellReuseId = "UserTopCell"
    
    private func commonInit() {
        registerCells()
    }
    
    private func registerCells() {
        registerReusableCell(UserCell.self)
        registerReusableCell(UserTopCell.self)
    }
}
