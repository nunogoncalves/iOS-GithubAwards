//
//  CreateListFromHTML.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 30/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import Kanna

extension Repositories {

    struct HTMLParser {
        
        static func repositories(containedIn html: String) -> [Repository] {

            guard let document = try? Kanna.HTML(html: html, encoding: .utf8) else { return [] }
            
            return repositoriesHTML(document).compactMap { repository(from: $0) }
        }

        private static func repositoriesHTML(_ document: HTMLDocument) -> XPathObject {
            return document.xpath("//*[contains(@class, 'Box-row')]")
        }

        private static func repository(from repoHTML: XMLElement) -> Repository? {
            guard let repoName = repositoryName(from: repoHTML), !repoName.isEmpty else { return nil }

            let starsCount = stars(from: repoHTML)
            let descr = description(from: repoHTML)
            let lang = language(from: repoHTML)

            return GitAwardsRepository(name: repoName, stars: starsCount, description: descr, language: lang)
        }

        private static func repositoryName(from document: XMLElement) -> String? {
            return document.css(".lh-condensed").makeIterator().next()?.text?.withoutSpaces()
        }
        
        private static func stars(from document: XMLElement) -> String {
            let total = document.css("a.mr-3").makeIterator().next()?.text?.withoutSpaces() ?? ""

            let stars = document.css("span.float-sm-right")
                                   .makeIterator().next()?.text?
                                   .withoutSpaces().substringUntil("stars") ?? ""
            
            return "\(total) (\(stars))"
        }
        
        private static func description(from document: XMLElement) -> String {
            guard let txt =  document.css("p.my-1").makeIterator().next()?.text else { return "" }
            
            return txt.trimmingCharacters(in: .whitespaces).replace("\n", with: "").replace("      ", with: "")
        }
        
        private static func language(from document: XMLElement) -> String? {
            if let element = document.css("span.mr-3").makeIterator().next() {
                return element.text?.withoutSpaces()
            }
            return nil
        }
    }
}
