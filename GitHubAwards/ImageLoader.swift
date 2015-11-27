//
//  ImageLoader.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 22/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit
import Foundation

class ImageLoader {
    static func fetchAndLoad(url: String, imageView: UIImageView, onFinished: () -> () = {}) {
        let url = NSURL(string: url)
        let qos = Int(QOS_CLASS_USER_INTERACTIVE.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) {
            let data = NSData(contentsOfURL: url!)
            dispatch_async(dispatch_get_main_queue()) {
                if let d = data {
                    imageView.image = UIImage(data: d)
                }
                onFinished()
            }
        }
    }
}
