//
//  TableStateListener.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 05/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

protocol TableStateListener : class {
    
    func newDataArrived<T>(_ page: Page<T>)
    func failedToGetData(_ status: NetworkStatus)
}
