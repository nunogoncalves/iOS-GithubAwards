//
//  NetworkResponse.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct Data {
    class ResponseHandler {
        
        var successCallback: (NSDictionary -> ())?
        var failureCallback: (ApiResponse -> ())?
        
        func success(data: NSDictionary) {
            successCallback?(data)
        }
        
        func failure(apiResponse: ApiResponse) {
            failureCallback?(apiResponse)
        }
    }
}