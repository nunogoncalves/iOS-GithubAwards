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
        
        var successCallback: ((JSON) -> ())?
        var failureCallback: ((ApiResponse) -> ())?
        
        func success(_ data: JSON) {
            successCallback?(data)
        }
        
        func failure(_ apiResponse: ApiResponse) {
            failureCallback?(apiResponse)
        }
    }
}
