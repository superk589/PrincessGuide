//
//  CharaTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/6/28.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import CoreData
import Gestalt

class CharaTableViewController: UITableViewController {

    var fetchedResultsController: NSFetchedResultsController<Chara>?
    var context: NSManagedObjectContext {
        return CoreDataStack.default.viewContext
    }
    
    var charas: [Chara] {
        return fetchedResultsController?.fetchedObjects ?? []
    }
    
    let backgroundImageView = UIImageView()
    
    private func prepareFetchRequest() {
        let request: NSFetchRequest<Chara> = Chara.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "modifiedAt", ascending: false)]
        request.returnsObjectsAsFaults = false
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        try? fetchedResultsController?.performFetch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Charas", comment: "")
        
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.tableView.indicatorStyle = theme.indicatorStyle
        }

        tableView.register(CharaTableViewCell.self, forCellReuseIdentifier: CharaTableViewCell.description())
        tableView.tableFooterView = UIView()
        prepareFetchRequest()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNavigationRightItem(_:)))
    }
    
    @objc private func handleNavigationRightItem(_ item: UIBarButtonItem) {
        let vc = ChooseCharaViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CharaTableViewCell.description(), for: indexPath) as! CharaTableViewCell
        let chara = charas[indexPath.row]
        cell.configure(for: chara)
        return cell
    }
}
