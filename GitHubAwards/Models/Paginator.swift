//
//  Paginator.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 27/11/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct Paginator {
    
    let currentPage: Int
    let totalPages: Int
    let totalCount: Int
    
    init(dictionary: NSDictionary = ["page": 1, "total_pages": 1, "total_count": 1]) {
        currentPage = dictionary["page"] as! Int
        totalPages = dictionary["total_pages"] as! Int
        totalCount = dictionary["total_count"] as! Int
    }
    
    func isFirstPage() -> Bool {
        return currentPage == 1
    }
    
    func isLastPage() -> Bool {
        return currentPage >= totalPages
    }
    
    func hasMorePages() -> Bool {
        return !isLastPage()
    }
    
}