//
//  MainTabBarController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 17/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

final class MainTabBarController: UITabBarController {

    private let main: MainCoordinator
    private let users: UsersCoordinator
    private let trending: TrendingCoordinator
    private let settings: SettingsCoordinator

    init(
        main: MainCoordinator,
        users: UsersCoordinator,
        trending: TrendingCoordinator,
        settings: SettingsCoordinator
    ) {
        self.main = main
        self.users = users
        self.trending = trending
        self.settings = settings

        super.init(nibName: nil, bundle: nil)

        viewControllers = ([main, users, trending, settings] as [Coordinator])
            .map { $0.navigationController }

        main.navigationController.tabBarItem = UITabBarItem(title: "Languages", image: #imageLiteral(resourceName: "Language")).vOffset(by: -5)
        users.navigationController.tabBarItem = UITabBarItem(title: "Users", image: #imageLiteral(resourceName: "UserActive")).vOffset(by: -5)
        trending.navigationController.tabBarItem = UITabBarItem(title: "Trending", image: #imageLiteral(resourceName: "Star")).vOffset(by: -5)
        settings.navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 0).vOffset(by: -5)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        main.start()
        users.start()
        trending.start()
        settings.start()
    }
}

private extension UITabBarItem {

    convenience init(title: String, image: UIImage) {
        self.init(title: title, image: image, selectedImage: nil)
    }

    func vOffset(by offset: CGFloat) -> UITabBarItem {
        titlePositionAdjustment = UIOffset(horizontal: 0, vertical: offset)
        return self
    }
}
