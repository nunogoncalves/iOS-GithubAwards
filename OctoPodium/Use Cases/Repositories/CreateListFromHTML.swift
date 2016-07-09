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
            var repositories = [Repository]()
            
            guard let document = Kanna.HTML(html: html, encoding: String.Encoding.utf8) else {
                return repositories
            }
            
            let metadataDocs = document.xpath("//*[contains(@class, 'repo-list-meta')]")
            
            for (i, repoHTML) in getRepositoriesHTML(document).enumerated() {
                
                let metadataDoc = metadataDocs[i]
                
                let repoName = getRepositoryNameFrom(repoHTML)
                let stars = getStarsFrom(metadataDoc)
                let description = getDescriptionFrom(repoHTML)
                let language = getLanguageFrom(metadataDoc)
                
                let repository = Repository(name: repoName, stars: stars, description: description, language: language)
                
                repositories.append(repository)                
            }
            return repositories
        }

        private static func getRepositoriesHTML(_ document: HTMLDocument) -> XPathObject {
            return document.xpath("//*[contains(@class, 'repo-list-item')]")
        }
        
        private static func getRepositoryNameFrom(_ document: XMLElement) -> String {
            return document.css("a")[1].text!.withoutSpaces()
        }
        
        private static func getStarsFrom(_ document: XMLElement) -> String {
            let metadata = document.text!.withoutSpaces()
            var stars = metadata.substringBetween("•", and: "stars")
            if stars == nil {
                stars = metadata.substringUntil("stars")
            }
            if stars == nil { stars = "0" }
            
            return stars!
        }
        
        private static func getDescriptionFrom(_ document: XMLElement) -> String {
            guard let txt = document.css("p.repo-list-description").makeIterator().next()?.text else { return "" }
            
            return txt.trimmingCharacters(in: NSCharacterSet.whitespaces()).replace("\n", with: "").replace("      ", with: "")
        }
        
        private static func getLanguageFrom(_ document: XMLElement) -> String? {
            let metadata = document.text!.withoutSpaces()
            
            let language = metadata.substringUntil("•")
            if language == nil || language! == "" || language!.contains("stars") {
                return nil
            }
            
            return language

        }
    }
}
