//
//  Paginator.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

class Paginator {
    
    let currentPage: Int
    let totalPages: Int
    let totalCount: Int
    
    init(dictionary: NSDictionary) {
        currentPage = dictionary["page"] as! Int
        totalPages = dictionary["total_pages"] as! Int
        totalCount = dictionary["total_count"] as! Int
    }
    
}