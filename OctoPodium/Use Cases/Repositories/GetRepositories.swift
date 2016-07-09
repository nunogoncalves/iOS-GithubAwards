////
////  GetList.swift
////  OctoPodium
////
////  Created by Nuno Gonçalves on 30/01/16.
////  Copyright © 2016 Nuno Gonçalves. All rights reserved.
////

extension Repositories {
    struct GetRepositories {
        func get(_ trending: String, language: String = "") -> [Repository] {
            do {
                let lang = language == "" ? language : "/\(language)/"
                let url = "https://github.com/trending\(lang)/?since=\(trending)"
                let html = try NSString(contentsOf: URL(string: url)!, encoding: String.Encoding.utf8.rawValue)
                return Repositories.CreateListFromHTML.list(html as String)
            } catch _ {
                return []
            }
        }
    }
}
