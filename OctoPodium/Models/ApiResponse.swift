//
//  ApiResponse.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 26/03/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

enum ApiResponseError: Error {
    case any(apiResponse: ApiResponse)

    var apiResponse: ApiResponse {
        switch self {
        case let .any(apiResponse): return apiResponse
        }
    }
}

struct ApiResponse {
    
    let status: NetworkStatus
    let json: JSON?
}
