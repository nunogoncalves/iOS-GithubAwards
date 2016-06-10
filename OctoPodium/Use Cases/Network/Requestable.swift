//
//  Getter.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 30/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

protocol Requestable {
    associatedtype Element
    
    var httpMethod: HTTPMethod { get }
    var headers: HeadParams? { get }
    var bodyParams: BodyParams? { get }

    func getUrl() -> String
    func getDataFrom(dictionary: NSDictionary) -> Element
    func call(success success: Element -> (), failure: ApiResponse -> ())

}

extension Requestable {
    
    func call(success success: Element -> (), failure: ApiResponse -> ()) {
        let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) {
            
            let responseHandler = Data.ResponseHandler()
            responseHandler.failureCallback = { apiResponse in
                dispatch_async(dispatch_get_main_queue()) {
                    failure(apiResponse)
                }
            }
            responseHandler.successCallback = { dictionary in
                let data = self.getDataFrom(dictionary)
                dispatch_async(dispatch_get_main_queue()) {
                    success(data)
                }
            }
            Network.Requester(networkResponseHandler: responseHandler).call(
                self.getUrl(),
                httpMethod: self.httpMethod,
                headers: self.headers,
                bodyParams: self.bodyParams)
        }
    }
}