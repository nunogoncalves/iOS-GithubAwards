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
    func getDataFrom(_ dictionary: NSDictionary) -> Element
    func call(success: @escaping (Element) -> (), failure: @escaping (ApiResponse) -> ())

}

extension Requestable {
    
    public func call(success: @escaping (Element) -> (), failure: @escaping (ApiResponse) -> ()) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            let responseHandler = Data.ResponseHandler()
            responseHandler.failureCallback = { apiResponse in
                DispatchQueue.main.async {
                    failure(apiResponse)
                }
            }
            responseHandler.successCallback = { dictionary in
                let data = self.getDataFrom(dictionary)
                DispatchQueue.main.async {
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
