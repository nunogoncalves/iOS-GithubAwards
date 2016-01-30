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
        static func list(html: String) -> [Repository] {
            var repositories = [Repository]()
            
            let document = Kanna.HTML(html: html, encoding: NSUTF8StringEncoding)
            guard document != nil else { return repositories }
            
            for repoHTML in getRepositoriesHTML(document!) {
                                
                let repoDoc = Kanna.HTML(html: repoHTML.innerHTML!, encoding: NSUTF8StringEncoding)
                
                let metadataDoc = repoDoc!.xpath("//*[contains(@class, 'repo-list-meta')]")
                
                let repoName = getRepositoryNameFrom(repoHTML)
                let stars = getStarsFrom(metadataDoc)
                let description = getDescription(repoHTML)
                
                let repository = Repository(name: repoName, stars: stars, description: description)
                
                repositories.append(repository)                
            }
            return repositories
        }

        private static func getRepositoriesHTML(document: HTMLDocument) -> XMLNodeSet {
            return document.xpath("//*[contains(@class, 'repo-list-item')]")
        }
        
        private static func getRepositoryNameFrom(document: XMLElement) -> String {
            return document.css("a")[1].text!.withoutSpaces()
        }
        
        private static func getStarsFrom(document: XMLNodeSet) -> String {
            let metadata = document.text!.withoutSpaces()
            
            var stars = metadata.substringBetween("•", and: "stars")
            if stars == nil {
                stars = metadata.substring("stars")
            }
            if stars == nil { stars = "0" }
            
            return stars!
        }
        
        private static func getDescription(document: XMLElement) -> String {
            return document.css("p.repo-list-description").text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).replace("\n", with: "").replace("      ", with: "")
        }
        
    }
}

private extension String {
    func withoutSpaces() -> String {
        return replace(" ", with: "")
            .replace("\n", with: "")
    }
    
    func replace(str: String, with w: String) -> String {
        return stringByReplacingOccurrencesOfString(str, withString: w)
    }
    
    func substringBetween(from: String, and to: String) -> String? {
        let range = rangeOfString("(?<=\(from))(.*?)(?=\(to))", options: .RegularExpressionSearch)
        guard range != nil else { return nil }
        return self.substringWithRange(range!)
    }
    
    func substring(until: String) -> String? {
        let range = rangeOfString(until)
        guard range != nil else { return nil }
        return self.substringToIndex(range!.startIndex)
    }
}
