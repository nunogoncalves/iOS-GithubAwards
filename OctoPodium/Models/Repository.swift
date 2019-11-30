//
//  Language.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 30/01/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

protocol Repository {

    var name: String { get }
    var fullName: String { get }
    var stars: String { get }
    var language: String? { get }
    var url: URL { get }
    var description: String { get }
    var user: String { get }
}

struct GitAwardsRepository: Repository {

    let name: String
    let stars: String
    let language: String?
    let url: URL
    let description: String
    let user: String

    init(name: String, stars: String, description: String, language: String?) {
        self.name = name.substring(after: "/") ?? ""
        self.stars = stars
        self.description = description
        self.language = language
        self.url = URL(string: "https://github.com/\(name)")!
        self.user = GitAwardsRepository.user(from: name)
    }

    var fullName: String {
        return "\(user)/\(name)"
    }
    
    private static func user(from name: String) -> String {
        return name.substringUntil("/") ?? ""
    }
}

struct GitHubRepository: Decodable, Repository {

    let name: String
    let fullName: String
    let stars: String
    let language: String?
    let url: URL
    let description: String
    let user: String

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let name = try values.decode(String.self, forKey: .name)
        self.name = name
        self.fullName = name
        self.stars = String(try values.decode(Int.self, forKey: .stars))
        self.language = try values.decode(String.self, forKey: .language)
        self.url = try values.decode(URL.self, forKey: .url)
        self.description = (try values.decode(Optional<String>.self, forKey: .description)) ?? ""

        let user = try values.decode(UserGithub.self, forKey: .user)
        self.user = user.name
    }

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case stars = "stargazers_count"
        case language
        case url
        case description
        case user = "owner"
    }

}

private struct UserGithub: Decodable {

    let name: String

    enum CodingKeys: String, CodingKey {
        case name = "login"
    }
}

struct GitHubRepositoryResponse: Decodable {

    let repositories: [GitHubRepository]

    enum CodingKeys: String, CodingKey {
        case repositories = "items"
    }
}
