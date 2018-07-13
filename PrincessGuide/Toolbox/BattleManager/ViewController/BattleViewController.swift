//
//  BattleViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/13.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt
import CoreData

class BattleTableViewController: UITableViewController {
    
    var fetchedResultsController: NSFetchedResultsController<Battle>?
    var context: NSManagedObjectContext {
        return CoreDataStack.default.viewContext
    }
    
    var battles: [Battle] {
        return fetchedResultsController?.fetchedObjects ?? []
    }
    
    let backgroundImageView = UIImageView()
    
    private func prepareFetchRequest() {
        let request: NSFetchRequest<Battle> = Battle.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "modifiedAt", ascending: false)]
        request.returnsObjectsAsFaults = false
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        try? fetchedResultsController?.performFetch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Battles", comment: "")
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.tableView.indicatorStyle = theme.indicatorStyle
            themeable.navigationController?.toolbar.barStyle = theme.barStyle
            themeable.navigationController?.toolbar.tintColor = theme.color.tint
            themeable.tableView.backgroundColor = theme.color.background
        }
        
        tableView.register(BattleTableViewCell.self, forCellReuseIdentifier: BattleTableViewCell.description())
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 104
        tableView.rowHeight = UITableViewAutomaticDimension
        prepareFetchRequest()
        
        navigationItem.rightBarButtonItems = [addItem, editButtonItem]
    }
    
    private(set) lazy var addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBattle(_:)))
    
    private(set) lazy var deleteItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(commitDeletion(_:)))
    
    private(set) lazy var selectItem = UIBarButtonItem(title: NSLocalizedString("Select All", comment: ""), style: .plain, target: self, action: #selector(selectAllBattles(_:)))
    private(set) lazy var deselectItem = UIBarButtonItem(title: NSLocalizedString("Deselect All", comment: ""), style: .plain, target: self, action: #selector(deselectAllBattles(_:)))
    private(set) lazy var copyItem = UIBarButtonItem(title: NSLocalizedString("Copy", comment: ""), style: .plain, target: self, action: #selector(copyBattles(_:)))
    private(set) lazy var spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if isEditing {
            navigationItem.rightBarButtonItems = [deleteItem, editButtonItem]
            navigationController?.setToolbarHidden(false, animated: true)
            toolbarItems = [selectItem, spaceItem, deselectItem, spaceItem, copyItem]
        } else {
            navigationItem.rightBarButtonItems = [addItem, editButtonItem]
            navigationController?.setToolbarHidden(true, animated: true)
            setToolbarItems(nil, animated: true)
        }
        tableView.beginUpdates()
        tableView.setEditing(editing, animated: animated)
        tableView.endUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
        setEditing(false, animated: true)
    }
    
    @objc private func addBattle(_ item: UIBarButtonItem) {
        let vc = ChooseMemberViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func commitDeletion(_ item: UIBarButtonItem) {
        for indexPath in (tableView.indexPathsForSelectedRows ?? [IndexPath]()).sorted(by: { $0.row > $1.row }) {
            context.delete(battles[indexPath.row])
        }
        do {
            try context.save()
        } catch (let error) {
            print(error)
        }
        setEditing(false, animated: true)
    }
    
    @objc private func selectAllBattles(_ item: UIBarButtonItem) {
        if isEditing {
            for i in 0..<battles.count {
                tableView.selectRow(at: IndexPath(row: i, section: 0), animated: false, scrollPosition: .none)
            }
        }
    }
    
    @objc private func deselectAllBattles(_ item: UIBarButtonItem) {
        if isEditing {
            for i in 0..<battles.count {
                tableView.deselectRow(at: IndexPath(row: i, section: 0), animated: false)
            }
        }
    }
    
    @objc private func copyBattles(_ item: UIBarButtonItem) {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows, isEditing {
            for indexPath in selectedIndexPaths.reversed() {
                let _ = Battle(anotherBattle: battles[indexPath.row], context: context)
            }
            do {
                try context.save()
            } catch (let error) {
                print(error)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return battles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let battle = battles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: BattleTableViewCell.description(), for: indexPath) as! BattleTableViewCell
        cell.configure(for: battle)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing { return }
        let battle = battles[indexPath.row]
//        let vc = EditTeamViewController(team: team)
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if isEditing {
            return UITableViewCellEditingStyle(rawValue: 0b11)!
        } else {
            return .delete
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(battles[indexPath.row])
            do {
                try context.save()
            } catch (let error) {
                print(error)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        navigationItem.rightBarButtonItems?[1] = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(customDone(_:)))
    }
    
    @objc private func customDone(_ item: UIBarButtonItem) {
        tableView.setEditing(false, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        navigationItem.rightBarButtonItems?[1] = editButtonItem
    }
    
}
