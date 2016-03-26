//
//  ApiResponse.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 26/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

struct ApiResponse {
    
    let status: NetworkStatus
    let responseDictionary: NSDictionary?
    
    init(status: NetworkStatus, responseDictionary: NSDictionary?) {
        self.status = status
        self.responseDictionary = responseDictionary
    }
}