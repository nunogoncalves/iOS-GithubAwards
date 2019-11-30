//
//  LanguagesPopoverController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 09/02/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

protocol LanguageSelectedProtocol: class {
    func didSelectLanguage(_ language: Language)
    func noLanguagesAvailable()
}

class LanguagesPopoverController: UIViewController {

    private let languagesTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain).usingAutoLayout()
        table.register(LanguageCell.self)
        return table
    }()

    weak var languageSelectorDelegate: LanguageSelectedProtocol?

    fileprivate var languages = [Language]()
    private let languagesFetcher: LanguageServiceProtocol

    init(languagesFetcher: LanguageServiceProtocol) {
        self.languagesFetcher = languagesFetcher
        super.init(nibName: nil, bundle: nil)

        view.addSubview(languagesTable)
        languagesTable.pinTo(marginsGuide: view.safeAreaLayoutGuide)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        languagesTable.dataSource = self
        languagesTable.delegate = self

        getLanguages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if languages.count == 0 {
            getLanguages()
        }
    }
    
    private func getLanguages() {
        self.languagesFetcher.getAll { result in
            switch result {
            case let .success(languages):
                self.languages = languages
                self.languages.insert("All Languages", at: 0)
                self.languagesTable.reloadData()
            case .failure(_):
                self.languageSelectorDelegate?.noLanguagesAvailable()
            }
        }
    }
}

extension LanguagesPopoverController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellFor(indexPath) as LanguageCell
        cell.render(with: languages[indexPath.row])
        return cell
    }
}

extension LanguagesPopoverController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        languageSelectorDelegate?.didSelectLanguage(languages[indexPath.row])
    }
}
