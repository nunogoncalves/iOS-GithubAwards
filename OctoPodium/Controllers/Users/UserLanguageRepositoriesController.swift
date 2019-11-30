//
//  UserLanguageRepositoriesController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 21/05/2019.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import Foundation
import Xtensions

final class UserLanguageReposotoriesController: UIViewController {

    private let languageTitleView = LanguageTitleView(frame: CGRect(x: 0.0, y: 0.0, width: 120.0, height: 40.0))

    private let loadingView: GithubLoadingView = create {
        $0.constrainSize(equalTo: Layout.Size.loadingView)
    }

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain).usingAutoLayout()
        table.registerReusableCell(TrendingRepositoryCell.self)
        table.estimatedRowHeight = 95.0
        table.rowHeight = UITableView.automaticDimension
        table.isHidden = true
        return table
    }()

    private var repositories: [Repository] = []

    private let user: User
    private let language: String

    init(user: User, language: String) {
        self.user = user
        self.language = language

        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .white
        view.addSubview(loadingView)
        view.addSubview(tableView)

        loadingView.center(==, tableView)
        tableView.pinTo(marginsGuide: view.safeAreaLayoutGuide)

        tableView.dataSource = self
        languageTitleView.render(with: language)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadingView.setLoading()
        navigationItem.titleView = languageTitleView

        DispatchQueue.global().async {
            searchOnGithub(username: self.user.login, language: self.language) { repositories in
                self.repositories = repositories
                DispatchQueue.main.async {

                    self.loadingView.stop()
                    self.loadingView.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension UserLanguageReposotoriesController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(for: indexPath) as TrendingRepositoryCell
        cell.repositorySince = (repository: repositories[indexPath.row], since: "")
        return cell
    }
}

func searchOnGithub(username: String, language: String, then: @escaping ([Repository]) -> ()) {

    let url = URL(string: "https://api.github.com/search/repositories")!

    var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
    urlComponents.queryItems = [
        URLQueryItem(name: "q", value: "language:\(language) user:\(username)"),
        URLQueryItem(name: "sort", value: "stars"),
    ]

    let request = URLRequest(url: urlComponents.url!)

    URLSession(
        configuration: URLSessionConfiguration.default
    ).dataTask(with: request) { (data, response, error) in
        let repositoryResponse = try! JSONDecoder().decode(GitHubRepositoryResponse.self, from: data!)
        then(repositoryResponse.repositories)
    }.resume()
}
