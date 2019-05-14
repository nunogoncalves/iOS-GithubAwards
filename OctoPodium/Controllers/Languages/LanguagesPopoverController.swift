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

    @IBOutlet weak var languagesTable: UITableView!
    
    weak var languageSelectorDelegate: LanguageSelectedProtocol?

    fileprivate var languages = [Language]()

    override func viewDidLoad() {
        super.viewDidLoad()
      
        languagesTable.dataSource = self
        languagesTable.delegate = self
        
        languagesTable.register(LanguageCell.self)
        
        getLanguages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if languages.count == 0 {
            getLanguages()
        }
    }
    
    private func getLanguages() {
        Languages.Get().getAll(
            success: { [weak self] languages in
                self?.languages = languages
                self?.languages.insert("All Languages", at: 0)
                self?.languagesTable.reloadData()
            },
            failure: { [weak self] _ in
                self?.languageSelectorDelegate?.noLanguagesAvailable()
            }
        )
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
        languageSelectorDelegate?.didSelectLanguage(languages[(indexPath as NSIndexPath).row])
    }
}
