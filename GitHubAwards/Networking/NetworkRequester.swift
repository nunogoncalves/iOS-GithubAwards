//
//  NetworkRequester.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

class NetworkRequester {

    let networkResponseHandler: NetworkResponse
    
    init(networkResponseHandler: NetworkResponse) {
        self.networkResponseHandler = networkResponseHandler
    }
    
    func makeGet(urlStr: String) {
        let url = NSURL(string: urlStr.urlEncoded())
        
        //http://stackoverflow.com/questions/24016142/how-to-make-an-http-request-in-swift
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: completionHandler)
        task.resume()
    }
    
    private func completionHandler(data: NSData?, response: NSURLResponse?, error: NSError?) {
        if let response = response as? NSHTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    let data = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    self.networkResponseHandler.success(data!)
                } catch _ {
                    self.networkResponseHandler.failure()
                }
            } else {
                self.networkResponseHandler.failure()
            }
        } else {
            self.networkResponseHandler.failure()
        }
    }
}