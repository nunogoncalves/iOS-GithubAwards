//
//  ShareRanking.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 13/06/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

private func canOpen(_ app: TwitterAppProtocol) -> Bool {
    return UIApplication.shared.canOpenURL(URL(string: app.scheme)!)
}

extension Twitter {

    struct Share {

        private static func appsWithUsername(_ username: String = "") -> [TwitterAppProtocol] {
            return [
                TweetBot(account: username),
                Tweeterific(account: username)
            ]
        }

        private static let appsWithoutUsername: [TwitterAppProtocol] = [
            Twitter()
        ]

        static var needsUrsername: Bool { return appsWithUsername().any { canOpen($0) } }

        static func perform(ranking: String, language: String, location: String, username: String? = nil) {

            let app: TwitterAppProtocol?
            if let username = username {
                app = appsWithUsername(username).first(where: { canOpen($0) })
            } else {
                app = appsWithoutUsername.first(where: { canOpen($0) })
            }

            let text = message(ranking: ranking, language: language, location: location).urlEncoded()

            guard let twitterApp = app else {
                postInTwitterBrowser(text)
                return
            }

            Analytics.SendToGoogle.shareRankingOnTwitterEvent(twitterApp.name)
            UIApplication.shared.open(twitterApp.postURL(message: text), options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }

        private static func appToShareContent(_ username: String?) -> TwitterAppProtocol? {

            if let username = username {
                return appsWithUsername(username).first(where: { canOpen($0) })
            } else {
                return appsWithoutUsername.first(where: { canOpen($0) })
            }
        }

        private static func postInTwitterBrowser(_ text: String) {
            Analytics.SendToGoogle.shareRankingOnTwitterEvent("Browser")
            Browser.openPage(URL(string: "https://twitter.com/intent/tweet?text=\(text)")!)
        }

        private static func message(ranking: String, language: String, location: String) -> String {
            return
                """
                I am the top \(ranking) \(language) developer in \(location).
                Check your GitHub ranking on #Octopodium #github-awards!
                """
        }
    }
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
