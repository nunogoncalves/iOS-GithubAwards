//
//  Coordinator.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 17/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation

protocol Coordinator: AnyObject {
    var children: [Coordinator] { get }
    var navigationController: UINavigationController { get }
    func start()
}
