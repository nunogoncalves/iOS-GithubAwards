//
//  CreateListFromHTML.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 30/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import SwiftSoup

extension Repositories {

    struct HTMLParser {
        
        static func repositories(containedIn html: String) -> [Repository] {

            guard let soup = try? SwiftSoup.parse(html),
                let repoHtmls = try? soup.body()?.getElementsByClass("Box-row")
            else { return [] }

            return repoHtmls.compactMap { repo -> GitAwardsRepository? in

                guard let name = try? repo.select(".lh-condensed").text().withoutSpaces(),
                    let stars = try? repo.select("a.mr-3").first()?.text(),
                    let language = try? repo.select("span.mr-3").first()?.text(),
                    let description = try? repo.select("p.my-1").first()?.text(),
                    let starsOfTime = try? repo.select("span.float-sm-right").text().substringUntil(" stars")
                else {
                    return nil
                }
                return GitAwardsRepository(
                    name: name,
                    stars: "\(stars) (\(starsOfTime))",
                    description: description,
                    language: language
                )
            }
        }
    }
}
