//
//  Page.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 10/12/17.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//
//

struct Page<T> {

    fileprivate (set) var items: [T]
    fileprivate (set) var currentPage: Int
    fileprivate (set) var totalPages: Int
    fileprivate (set) var totalCount: Int

    mutating func next(from anotherPage: Page) {

        self.items.append(contentsOf: anotherPage.items)
        self.currentPage = anotherPage.currentPage
        self.totalPages = anotherPage.totalPages
        self.totalCount = anotherPage.totalCount
    }

    var localCount: Int {
        return items.count
    }

    var isFirstPage: Bool {
        return currentPage == 1
    }

    var isLastPage: Bool {
        return currentPage >= totalPages
    }

    var hasMorePages: Bool {
        return !isLastPage
    }

    subscript(_ index: Int) -> T {

        return items[index]
    }

}
