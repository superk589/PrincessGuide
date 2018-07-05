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
        // preload
        fetchedResultsController?.fetchedObjects?.forEach { _ = Card.findByID(Int($0.id)) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Charas", comment: "")
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.tableView.indicatorStyle = theme.indicatorStyle
            themeable.navigationController?.toolbar.barStyle = theme.barStyle
            themeable.navigationController?.toolbar.tintColor = theme.color.tint
        }

        tableView.register(CharaTableViewCell.self, forCellReuseIdentifier: CharaTableViewCell.description())
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 103
        tableView.rowHeight = UITableViewAutomaticDimension
        prepareFetchRequest()
        
        navigationItem.rightBarButtonItems = [addItem, editButtonItem]
    }
    
    private(set) lazy var addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addChara(_:)))
    
    private(set) lazy var  deleteItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(commitDeletion(_:)))
    
    private(set) lazy var selectItem = UIBarButtonItem(title: NSLocalizedString("Select All", comment: ""), style: .plain, target: self, action: #selector(selectAllCharas(_:)))
    private(set) lazy var deselectItem = UIBarButtonItem(title: NSLocalizedString("Deselect All", comment: ""), style: .plain, target: self, action: #selector(deselectAllCharas(_:)))
    private(set) lazy var copyItem = UIBarButtonItem(title: NSLocalizedString("Copy", comment: ""), style: .plain, target: self, action: #selector(copyCharas(_:)))
    private(set) lazy var spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    private(set) lazy var batchEditItem = UIBarButtonItem(title: NSLocalizedString("Batch Edit", comment: ""), style: .plain, target: self, action: #selector(batchEdit(_:)))
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if isEditing {
            navigationItem.rightBarButtonItems = [deleteItem, editButtonItem]
            navigationController?.setToolbarHidden(false, animated: true)
            toolbarItems = [selectItem, spaceItem, deselectItem, spaceItem, copyItem, spaceItem, batchEditItem]
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
    
    @objc private func addChara(_ item: UIBarButtonItem) {
        let vc = ChooseCharaViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func commitDeletion(_ item: UIBarButtonItem) {
        for indexPath in (tableView.indexPathsForSelectedRows ?? [IndexPath]()).sorted(by: { $0.row > $1.row }) {
            context.delete(charas[indexPath.row])
        }
        do {
            try context.save()
        } catch (let error) {
            print(error)
        }
        setEditing(false, animated: true)
    }
    
    @objc private func selectAllCharas(_ item: UIBarButtonItem) {
        if isEditing {
            for i in 0..<charas.count {
                tableView.selectRow(at: IndexPath(row: i, section: 0), animated: false, scrollPosition: .none)
            }
        }
    }
    
    @objc private func deselectAllCharas(_ item: UIBarButtonItem) {
        if isEditing {
            for i in 0..<charas.count {
                tableView.deselectRow(at: IndexPath(row: i, section: 0), animated: false)
            }
        }
    }
    
    @objc private func copyCharas(_ item: UIBarButtonItem) {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows, isEditing {
            for indexPath in selectedIndexPaths {
                let _ = Chara(anotherChara: charas[indexPath.row], context: context)
            }
            do {
                try context.save()
            } catch (let error) {
                print(error)
            }
        }
    }
    
    @objc private func batchEdit(_ item: UIBarButtonItem) {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows, isEditing, selectedIndexPaths.count > 0 {
            let charas = selectedIndexPaths.map { self.charas[$0.row] }
            let vc = BatchEditViewController(charas: charas)
            navigationController?.pushViewController(vc, animated: true)
        }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing { return }
        let chara = charas[indexPath.row]
        let vc = EditCharaViewController(chara: chara)
        navigationController?.pushViewController(vc, animated: true)
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
            context.delete(charas[indexPath.row])
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

extension Chara {
    
    convenience init(anotherChara: Chara, context: NSManagedObjectContext) {
        self.init(context: context)
        bondRank = anotherChara.bondRank
        level = anotherChara.level
        rank = anotherChara.rank
        skillLevel = anotherChara.skillLevel
        slot1 = anotherChara.slot1
        slot2 = anotherChara.slot2
        slot3 = anotherChara.slot3
        slot4 = anotherChara.slot4
        slot5 = anotherChara.slot5
        slot6 = anotherChara.slot6
        modifiedAt = Date()
        id = anotherChara.id
        rarity = anotherChara.rarity
    }
    
    var card: Card? {
        return Card.findByID(Int(id))
    }
}
