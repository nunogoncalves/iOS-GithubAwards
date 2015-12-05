//
//  PaginatorTests.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 05/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import XCTest
@testable import GitHubAwards

class PaginatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testTotalPages() {
        let dictionary = [
            "page" : 1,
            "total_pages": 10,
            "total_count": 100
        ]
        let paginator = Paginator(dictionary: dictionary)
        
        XCTAssertEqual(paginator.currentPage, 1)
        XCTAssertEqual(paginator.totalPages, 10)
        XCTAssertEqual(paginator.totalCount, 100)
    }
    
    func testIsNotLastPage() {
        let dictionary = [
            "page" : 1,
            "total_pages": 10,
            "total_count": 100
        ]
        let paginator = Paginator(dictionary: dictionary)
        
        XCTAssertEqual(paginator.isLastPage(), false)
        XCTAssertEqual(paginator.isFirstPage(), true)
    }
    
    func testIsLastPage() {
        let dictionary = [
            "page" : 10,
            "total_pages": 10,
            "total_count": 100
        ]
        let paginator = Paginator(dictionary: dictionary)
        
        XCTAssertEqual(paginator.isLastPage(), true)
        XCTAssertEqual(paginator.hasMorePages(), false)
        XCTAssertEqual(paginator.isFirstPage(), false)
    }
    
    func testPerformanceExample() {
        self.measureBlock {
        }
    }
    
}
