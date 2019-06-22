#!/usr/bin/ruby
#encoding: utf-8
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8


github_creds_contents = <<-HEREDOC
//
//  GithubCreds.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 06/04/2018.
//  Copyright © 2018 Nuno Gonçalves. All rights reserved.
//

struct GithubCreds {

    static let clientId = "#{ENV['GITHUB_OCTOPODIUM_CLIENT_ID']}"
    static let clientSecret = "#{ENV['GITHUB_OCTOPODIUM_CLIENT_SECRET']}"
}
HEREDOC

github_creds_file = File.new("Octopodium/Models/GithubCredentials.swift", "w")
github_creds_file.puts(github_creds_contents)
github_creds_file.close