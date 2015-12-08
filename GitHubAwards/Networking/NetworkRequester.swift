//
//  NetworkRequester.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

class NetworkRequester {
    
    static func makeGet(urlStr: String, networdResponseHandler: NetworkResponse) {
        //http://stackoverflow.com/questions/24016142/how-to-make-an-http-request-in-swift
        let url = NSURL(string: urlStr.urlEncoded())
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            if let response = response as? NSHTTPURLResponse {
                if response.statusCode == 200 {
                    do {
                        let data = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                        networdResponseHandler.success(data!)
                    } catch _ {
                        networdResponseHandler.failure()
                    }
                } else {
                    networdResponseHandler.failure()
                }
            } else {
                networdResponseHandler.failure()
            }
        }
        
        task.resume()
    }
    
    
}