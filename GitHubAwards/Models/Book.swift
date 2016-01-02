//
//  Book.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 05/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

protocol Book {
    
    var paginator: Paginator { get set }
    var data: [AnyObject] { get set }
    
    func hasMorePages() -> Bool
}