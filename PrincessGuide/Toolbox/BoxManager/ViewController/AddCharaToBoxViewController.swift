//
//  AddCharaToBoxViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/5.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import CoreData

protocol AddCharaToBoxViewControllerDelegate: AnyObject {
    func addCharaToBoxViewControllerDidSave(_ addCharaToBoxViewController: AddCharaToBoxViewController)
}

class AddCharaToBoxViewController: UITableViewController {
    
    weak var delegate: AddCharaToBoxViewControllerDelegate?
    
    let box: Box
    
    let parentContext: NSManagedObjectContext
    
    let context: NSManagedObjectContext
    
    init(box: Box, parentContext: NSManagedObjectContext) {
        self.parentContext = parentContext
        context = CoreDataStack.default.newChildContext(parent: parentContext)
        self.box = context.object(with: box.objectID) as! Box
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Charas", comment: "")
        tableView.cellLayoutMarginsFollowReadableWidth = true
                
        tableView.register(CharaTableViewCell.self, forCellReuseIdentifier: CharaTableViewCell.description())
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 103
        tableView.rowHeight = UITableView.automaticDimension
        prepareFetchRequest()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveCharas(_:)))
        toolbarItems = [selectItem, spaceItem, deselectItem]
        tableView.setEditing(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }

    @objc private func selectAllCharas(_ item: UIBarButtonItem) {
        for i in 0..<charas.count {
            tableView.selectRow(at: IndexPath(row: i, section: 0), animated: false, scrollPosition: .none)
        }
        box.addToCharas(NSSet(array: charas))
    }
    
    @objc private func deselectAllCharas(_ item: UIBarButtonItem) {
        for i in 0..<charas.count {
            tableView.deselectRow(at: IndexPath(row: i, section: 0), animated: false)
        }
        box.removeFromCharas(NSSet(array: charas))
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return UITableViewCell.EditingStyle(rawValue: 0b11)!
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let boxCharas = box.charas, boxCharas.contains(charas[indexPath.row]) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        box.addToCharas(charas[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        box.removeFromCharas(charas[indexPath.row])
    }
    
    @objc private func saveCharas(_ item: UIBarButtonItem) {
        box.modifiedAt = Date()
        do {
            try context.save()
            // try parentContext.save()
        } catch (let error) {
            print(error)
        }
        navigationController?.popViewController(animated: true)
        delegate?.addCharaToBoxViewControllerDidSave(self)
    }
    
    var fetchedResultsController: NSFetchedResultsController<Chara>?
    
    var charas: [Chara] {
        return fetchedResultsController?.fetchedObjects ?? []
    }
        
    private func prepareFetchRequest() {
        let request: NSFetchRequest<Chara> = Chara.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "modifiedAt", ascending: false)]
        request.returnsObjectsAsFaults = false
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        try? fetchedResultsController?.performFetch()
    }
    
    private(set) lazy var selectItem = UIBarButtonItem(title: NSLocalizedString("Select All", comment: ""), style: .plain, target: self, action: #selector(selectAllCharas(_:)))
    private(set) lazy var deselectItem = UIBarButtonItem(title: NSLocalizedString("Deselect All", comment: ""), style: .plain, target: self, action: #selector(deselectAllCharas(_:)))
    private(set) lazy var spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
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
