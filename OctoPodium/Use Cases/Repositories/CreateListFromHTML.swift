//
//  CreateListFromHTML.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 30/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Kanna

extension Repositories {
    class CreateListFromHTML {
        
        static func list(_ html: String) -> [Repository] {
            
            guard let document = Kanna.HTML(html: html, encoding: .utf8) else { return [] }
           
            var repositories: [Repository] = []
            
            for repoHTML in getRepositoriesHTML(document) {
              repositories.append(repository(from: repoHTML))
            }
            return repositories
        }
        
        private static func repository(from repoHTML: XMLElement) -> Repository {
            let repoName = getRepositoryNameFrom(repoHTML)
            let stars = getStarsFrom(repoHTML)
            let description = getDescriptionFrom(repoHTML)
            let language = getLanguageFrom(repoHTML)

            return Repository(name: repoName, stars: stars, description: description, language: language)
        }

        private static func getRepositoriesHTML(_ document: HTMLDocument) -> XPathObject {
            return document.xpath("//*[contains(@class, 'py-4')]")
        }
        
        private static func getRepositoryNameFrom(_ document: XMLElement) -> String {
            return document.css("a").makeIterator().next()?.text?.withoutSpaces() ?? ""
        }
        
        private static func getStarsFrom(_ document: XMLElement) -> String {
            let total = document.css("a.mr-3").makeIterator().next()?.text?.withoutSpaces() ?? ""
            
            let stars = document.css("span.float-right")
                                   .makeIterator().next()?.text?
                                   .withoutSpaces().substringUntil("stars") ?? ""
            
            return "\(total) (\(stars))"
        }
        
        private static func getDescriptionFrom(_ document: XMLElement) -> String {
            guard let txt =  document.css("div.py-1").makeIterator().next()?.text else { return "" }
            
            return txt.trimmingCharacters(in: .whitespaces).replace("\n", with: "").replace("      ", with: "")
        }
        
        private static func getLanguageFrom(_ document: XMLElement) -> String? {
            if let element = document.css("span.mr-3").makeIterator().next() {
                return element.text?.withoutSpaces()
            }
            return nil
        }
    }
}
