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

goolge_plist_contents = <<-GOOGLE
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>TRACKING_ID</key>
  <string>#{ENV['GOOGLE_TRACKING_ID']}</string>
  <key>PLIST_VERSION</key>
  <string>1</string>
  <key>BUNDLE_ID</key>
  <string>com.numicago.ios.octopodium</string>
  <key>IS_ADS_ENABLED</key>
  <false/>
  <key>IS_ANALYTICS_ENABLED</key>
  <true/>
  <key>IS_APPINVITE_ENABLED</key>
  <false/>
  <key>IS_GCM_ENABLED</key>
  <false/>
  <key>IS_SIGNIN_ENABLED</key>
  <false/>
  <key>GOOGLE_APP_ID</key>
  <string>#{ENV['GOOGLE_APP_ID']}</string>
</dict>
</plist>
GOOGLE

google_plist_file = File.new("Octopodium/Supporting Files/GoogleService-Info.plist", "w")
google_plist_file.puts(goolge_plist_contents)
google_plist_file.close
