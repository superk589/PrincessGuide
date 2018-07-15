//
//  BDInfoViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import CoreData
import Gestalt

protocol BDInfoConfigurable {
    func configure(for model: BDInfoViewController.Row.Model)
}

class BDInfoViewController: UITableViewController {
    
    let parentContext: NSManagedObjectContext?
    
    let context: NSManagedObjectContext
    
    let box: Box
    
    struct Row {
        enum Model {
            case text([(String, String)])
            case basic(Int?, String)
        }
        var type: UITableViewCell.Type
        var data: Model
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
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.tableView.indicatorStyle = theme.indicatorStyle
            themeable.navigationController?.toolbar.barStyle = theme.barStyle
            themeable.navigationController?.toolbar.tintColor = theme.color.tint
        }
        tableView.register(BDInfoTextCell.self, forCellReuseIdentifier: BDInfoTextCell.description())
        tableView.register(BoxTableViewCell.self, forCellReuseIdentifier: BoxTableViewCell.description())
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        loadData()
    }

    private func loadData() {
        let objectID = box.objectID
        LoadingHUDManager.default.show()
        context.perform { [weak self] in
            var rows = [Row]()
            
            let box = self?.context.object(with: objectID) as? Box
            let charas = box?.charas?.array as? [Chara] ?? []
            rows.append(Row(type: BoxTableViewCell.self, data: .basic(charas.first?.iconID, box?.name ?? "")))
            rows.append(Row(type: BDInfoTextCell.self, data: .text([
                    (NSLocalizedString("Charas Count", comment: ""),
                     String(charas.count))
                ])))
            
            let craftCost = charas.flatMap { $0.unequiped() }
                .flatMap { $0.recursiveCraft }
                .reduce(0) { $0 + $1.craftedCost }
            rows.append(Row(type: BDInfoTextCell.self, data: .text([
                (NSLocalizedString("Mana Cost of Crafting", comment: ""),
                 craftCost.formatted)
            ])))
            
            let enhanceCost = charas.flatMap { $0.maxRankUnequiped() }
                .reduce(0) { $0 + $1.enhanceCost }
            rows.append(Row(type: BDInfoTextCell.self, data: .text([
                (NSLocalizedString("Mana Cost of Enhancing", comment: ""),
                 enhanceCost.formatted)
            ])))
            
            let skillCost = charas.reduce(0) { $0 + $1.skillLevelUpCost }
            rows.append(Row(type: BDInfoTextCell.self, data: .text([
                (NSLocalizedString("Mana Cost of Skill Training", comment: ""),
                 skillCost.formatted)
            ])))
            
            let totalManaCost = craftCost + enhanceCost + skillCost
            rows.append(Row(type: BDInfoTextCell.self, data: .text([
                (NSLocalizedString("Total Mana Cost", comment: ""),
                 totalManaCost.formatted)
            ])))
            
            let totalExperience = charas.reduce(0) { $0 + $1.experienceToMaxLevel }
            rows.append(Row(type: BDInfoTextCell.self, data: .text([
                (NSLocalizedString("Total Experience Needed", comment: ""),
                 totalExperience.formatted)
            ])))
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: row.type.description(), for: indexPath) as! BDInfoConfigurable
        cell.configure(for: row.data)
        return cell as! UITableViewCell
    }
}

extension Int {
    
    var formatted: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: self) ?? ""
    }
}
