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

                let html = try String(contentsOf: URL(string: url)!, encoding: .utf8)

                return Repositories.HTMLParser.list(from: html)

            } catch _ {
                return []
            }
        }
    }
}
