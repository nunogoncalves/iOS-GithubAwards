//
//  SearchBar.swift
//  GitHubAwards
//
//  Created by Nuno Gonçalves on 12/12/15.
//  Copyright © 2015 Nuno Gonçalves. All rights reserved.
//

import UIKit

class SearchBar : UISearchBar {
    
    weak var searchDelegate: UISearchBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        delegate = self
    }
}

extension SearchBar : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        if (searchDelegate?.searchBarTextDidBeginEditing != nil) {
            searchDelegate?.searchBarTextDidBeginEditing!(searchBar)
        }
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        if (searchDelegate?.searchBarCancelButtonClicked != nil) {
            searchDelegate?.searchBarCancelButtonClicked!(searchBar)
        }
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if (searchDelegate?.searchBarSearchButtonClicked != nil) {
            searchDelegate?.searchBarSearchButtonClicked!(searchBar)
        }
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if let textDidChange: (UISearchBar, String) -> Void = searchDelegate?.searchBar {
            textDidChange(searchBar, searchText)
        }
    }
}