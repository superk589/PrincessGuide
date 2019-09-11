//
//  BDInfoViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import CoreData

class BDInfoViewController: UITableViewController {
    
    let parentContext: NSManagedObjectContext?
    
    let context: NSManagedObjectContext
    
    let box: Box
    
    enum Row {
        case textArray([TextItem])
        case basic(URL?, String)
    }
    
    var rows = [Row]()
    
    private var observer: ManagedObjectObserver?

    init(box: Box) {
        parentContext = box.managedObjectContext
        context = CoreDataStack.default.newChildContext(parent: parentContext ?? CoreDataStack.default.viewContext, concurrencyType: .privateQueueConcurrencyType)
        self.box = box
        super.init(nibName: nil, bundle: nil)
        
        observer = ManagedObjectObserver(object: box, changeHandler: { [weak self] (type) in
            if type == .delete {
                self?.navigationController?.popViewController(animated: true)
            } else if type == .update {
                self?.loadData()
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(cellType: CDProfileTableViewCell.self)
        tableView.register(cellType: BoxTableViewCell.self)
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 60
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        loadData()
    }

    private func loadData() {
        let objectID = box.objectID
        LoadingHUDManager.default.show()
        context.perform { [weak self] in
            var rows = [Row]()
            
            let box = self?.context.object(with: objectID) as? Box
            let charas = box?.charas?.allObjects as? [Chara] ?? []
            rows.append(Row.basic(charas.first?.iconURL, box?.name ?? ""))
            rows.append(Row.textArray([
                TextItem(title: NSLocalizedString("Charas Count", comment: ""), content: String(charas.count), colorMode: .normal)
            ]))
            
            let craftCost = charas.flatMap { $0.unequiped() }
                .flatMap { $0.recursiveCraft }
                .reduce(0) { $0 + $1.craftedCost }
            rows.append(Row.textArray([
                TextItem(title: NSLocalizedString("Mana Cost of Crafting", comment: ""), content: craftCost.formatted, colorMode: .normal)
            ]))
            let enhanceCost = charas.flatMap { $0.maxRankUnequiped() }
                .reduce(0) { $0 + $1.enhanceCost }
            rows.append(Row.textArray([
                TextItem(title: NSLocalizedString("Mana Cost of Enhancing", comment: ""), content: enhanceCost.formatted, colorMode: .normal)
            ]))
            let skillCost = charas.reduce(0) { $0 + $1.skillLevelUpCost }
            rows.append(Row.textArray([
                TextItem(title: NSLocalizedString("Mana Cost of Skill Training", comment: ""), content: skillCost.formatted, colorMode: .normal)
            ]))
            
            let uniqueEquipmentCraftCost = charas
                .flatMap { $0.uniqueUnequiped() }
                .reduce(0) { $0 + ($1.craft?.craftedCost ?? 0) }
            rows.append(Row.textArray([
                TextItem(title: NSLocalizedString("Mana Cost of Unique Equipment Crafting", comment: ""), content: uniqueEquipmentCraftCost.formatted, colorMode: .normal)
            ]))
            
            let uniqueEquipmentEnhanceCost = charas
                .reduce(0) { $0 + $1.uniqueEquipmentEnhanceCost }
            rows.append(Row.textArray([
                TextItem(title: NSLocalizedString("Mana Cost of Unique Equipment Enhancing", comment: ""), content: uniqueEquipmentEnhanceCost.formatted, colorMode: .normal)
            ]))
            
            let totalManaCost = craftCost + enhanceCost + skillCost + uniqueEquipmentCraftCost + uniqueEquipmentEnhanceCost
            rows.append(Row.textArray([
                TextItem(title: NSLocalizedString("Total Mana Cost", comment: ""), content: totalManaCost.formatted, colorMode: .normal)
            ]))
            
            let totalExperience = charas.reduce(0) { $0 + $1.experienceToMaxLevel }
            rows.append(Row.textArray([
                TextItem(title: NSLocalizedString("Total Experience Needed", comment: ""), content: totalExperience.formatted, colorMode: .normal)
            ]))
            
            DispatchQueue.main.async {
                LoadingHUDManager.default.hide()
                self?.rows = rows
                self?.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        switch row {
        case .basic(let url, let name):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BoxTableViewCell.self)
            cell.configure(
                iconURL: url,
                name: name
            )
            return cell
        case .textArray(let items):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDProfileTableViewCell.self)
            cell.configure(items: items)
            return cell
        }
    }
}

extension Int {
    
    var formatted: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: self) ?? ""
    }
}
