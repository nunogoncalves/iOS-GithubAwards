//
//  NetworkResponse.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

class NetworkResponse {
    
    var successCallback: (NSDictionary -> ())?
    var failureCallback: (() -> ())?
    
    func success(data: NSDictionary) {
        successCallback?(data)
    }
    
    func failure() {
        failureCallback?()
    }
    
}
