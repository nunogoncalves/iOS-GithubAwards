//
//  Getter.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 30/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//
typealias JSON = [String: Any]

protocol Requestable {
    associatedtype Element
    
    var url: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HeadParams? { get }
    var bodyParams: BodyParams? { get }

    func parse(_ json: JSON) -> Element
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
                let data = self.parse(dictionary)
                DispatchQueue.main.async {
                    success(data)
                }
            }
            Network.Requester(networkResponseHandler: responseHandler).call(
                self.url,
                httpMethod: self.httpMethod,
                headers: self.headers,
                bodyParams: self.bodyParams)
        }
    }
}
