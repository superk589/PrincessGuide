//
//  CDTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/6.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class CDTableViewController: UITableViewController, CDImageTableViewCellDelegate {
    
    struct Row {
        enum Model {
            case card(Card)
            case skill(Skill, SkillCategory, Property, Int?)
            case base(Card.Base)
            case profile(Card.Profile)
            case pattern(AttackPattern, Card, Int?)
            case promotion(Card.Promotion)
            case profileItems([Card.Profile.Item])
            case propertyItems([Property.Item], Int, Int, Bool)
            case comment(Card.Comment)
            case text(String, String, Bool)
            case textArray([(String, String, Bool)])
            case album(String, [URL], [URL])
            case commentText(String)
        }
        var type: UITableViewCell.Type
        var data: Model
    }
    
    var card: Card? {
        didSet {
            reloadAll()
        }
    }
    
    func reloadAll() {
        navigationItem.title = card?.base.unitName
        if let card = card {
            prepareRows(for: card)
            registerRows()
            tableView.reloadData()
        }
    }
    
    var rows = [Row]()
    
    /// should be overrided by subclasses
    func prepareRows(for card: Card) {

    }
    
    func registerRows() {
        for row in rows {
            tableView.register(row.type.self, forCellReuseIdentifier: row.type.description())
        }
    }
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.tableView.indicatorStyle = theme.indicatorStyle
        }
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] (context) in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
            }, completion: nil)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: model.type.description(), for: indexPath) as! CardDetailConfigurable
        cell.configure(for: model.data)
        
        if let cell = cell as? CDPromotionTableViewCell {
            cell.delegate = self
        } else if let cell = cell as? CDImageTableViewCell {
            cell.delegate = self
        }
        
        return cell as! UITableViewCell
    }
    
    func cdImageTableViewCell(_ cdImageTableViewCell: CDImageTableViewCell, didSelect imageView: UIImageView, url: URL?) {
        
    }
}

extension CDTableViewController: CDPromotionTableViewCellDelegate {
    
    func cdPromotionTableViewCell(_ cdPromotionTableViewCell: CDPromotionTableViewCell, didSelectEquipmentID equipmentID: Int) {
        
        let equipments = DispatchSemaphore.sync { (closure) in
            Master.shared.getEquipments(equipmentID: equipmentID) { equipments in
                closure(equipments)
            }
        }
        guard let equipment = equipments?.first else {
            return
        }
        if equipment.craftFlg == 0 {
            DropSummaryTableViewController.configureAsync(equipment: equipment) { [weak self] (vc) in
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            let vc = CraftTableViewController()
            vc.navigationItem.title = equipment.equipmentName
            vc.equipment = equipment
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
