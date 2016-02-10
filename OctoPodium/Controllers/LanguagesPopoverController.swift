//
//  LanguagesPopoverController.swift
//  OctoPodium
//
//  Created by Nuno Gonçalves on 09/02/16.
//  Copyright © 2016 Nuno Gonçalves. All rights reserved.
//

import UIKit

protocol LanguageSelectedProtocol: class {
    func didSelectLanguage(language: Language)
    func noLanguagesAvailable()
}

class LanguagesPopoverController: UIViewController {

    @IBOutlet weak var languagesTable: UITableView!
    
    weak var languageSelectorDelegate: LanguageSelectedProtocol?

    private var languages = [Language]()

    override func viewDidLoad() {
        super.viewDidLoad()
      
        languagesTable.dataSource = self
        languagesTable.delegate = self
        
        languagesTable.registerReusableCell(LanguageCell)
        
        getLanguages()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if languages.count == 0 {
            getLanguages()
        }
    }
    
    private func getLanguages() {
        Languages.Get().getAll(
            success: { [weak self] languages in
                self?.languages = languages
                self?.languages.insert("All Languages", atIndex: 0)
                self?.languagesTable.reloadData()
            },
            failure: { [weak self] _ in
                self?.languageSelectorDelegate?.noLanguagesAvailable()
            }
        )
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension LanguagesPopoverController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellFor(indexPath) as LanguageCell
        
        cell.language = languages[indexPath.row]
        
        return cell
    }
}

extension LanguagesPopoverController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        languageSelectorDelegate?.didSelectLanguage(languages[indexPath.row])
    }
}
