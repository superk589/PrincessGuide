//
//  CraftTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/3.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class CraftTableViewController: UITableViewController {
    
    struct Row {
        enum Model {
            case summary(Equipment)
            case consume(Craft.Consume)
            case properties([Property.Item])
            case text(String, String)
        }
        var type: UITableViewCell.Type
        var data: Model
    }
    
    var equipment: Equipment? {
        didSet {
            if let _ = equipment {
                prepareRows()
                registerRows()
                tableView.reloadData()
            }
        }
    }
    
    private var rows = [Row]()
    
    private func registerRows() {
        rows.forEach {
            tableView.register($0.type, forCellReuseIdentifier: $0.type.description())
        }
    }
    
    private func prepareRows() {
        rows.removeAll()
        guard let equipment = equipment, let craft = equipment.craft else {
            return
        }
        rows = [Row(type: CraftSummaryTableViewCell.self, data: .summary(equipment))]
        
        rows += craft.consumes.map { Row(type: CraftTableViewCell.self, data: .consume($0)) }
        rows += equipment.property.noneZeroProperties().map { Row(type: CraftPropertyTableViewCell.self, data: .properties([$0])) }
        
        let craftCost = equipment.recursiveCraft.reduce(0) { $0 + $1.craftedCost }
        let enhanceCost = equipment.enhanceCost
        rows += [Row(type: CraftTextTableViewCell.self, data: .text(NSLocalizedString("Mana Cost of Crafting", comment: ""), String(craftCost)))]
        rows += [Row(type: CraftTextTableViewCell.self, data: .text(NSLocalizedString("Mana Cost of Enhancing", comment: ""), String(enhanceCost)))]

        rows.append(Row(type: CraftTextTableViewCell.self, data: .text(NSLocalizedString("Description", comment: ""), equipment.description)))
    }
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.tableView.indicatorStyle = theme.indicatorStyle
        }
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.estimatedRowHeight = 84
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(CraftSummaryTableViewCell.self, forCellReuseIdentifier: CraftSummaryTableViewCell.description())
        tableView.register(CraftTableViewCell.self, forCellReuseIdentifier: CraftTableViewCell.description())
        tableView.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = rows[indexPath.row]
        switch row.data {
        case .consume(let consume):
            if let equipment = consume.equipment {
                if equipment.craftFlg == 0 {
                    DropSummaryTableViewController.configureAsync(equipment: equipment, callback: { [weak self] (vc) in
                        self?.navigationController?.pushViewController(vc, animated: true)
                    })
                } else {
                    let vc = CraftTableViewController()
                    vc.navigationItem.title = equipment.equipmentName
                    vc.equipment = equipment
                    vc.hidesBottomBarWhenPushed = true
                    LoadingHUDManager.default.hide()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: model.type.description(), for: indexPath) as! CraftDetailConfigurable
        cell.configure(for: model.data)
        
        if let cell = cell as? CraftSummaryTableViewCell {
            cell.delegate = self
        }
        
        return cell as! UITableViewCell
    }
    
}

extension CraftTableViewController: CraftSummaryTableViewCellDelegate {
    
    func craftSummaryTableViewCell(_ craftSummaryTableViewCell: CraftSummaryTableViewCell, didSelect consume: Craft.Consume) {
        if let equipment = consume.equipment {
            DropSummaryTableViewController.configureAsync(equipment: equipment) { [weak self] (vc) in
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
