//
//  CDTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/6.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class CDTableViewController: UITableViewController {
    
    struct Row {
        enum Model {
            case skill(Skill, SkillCategory)
            case base(Card.Base)
            case profile(Card.Profile)
            case pattern(AttackPattern, Card)
            case promotion(Card.Promotion)
            case profileItems([Card.Profile.Item])
            case propertyItems([Property.Item])
            case comment(Card.Comment)
            case text(String, String)
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
    
    func prepareRows(for card: Card) {
        rows.removeAll()
        
        rows.append(Row(type: CDBasicTableViewCell.self, data: .profile(card.profile)))
        
        card.patterns?.forEach {
            rows.append(Row(type: CDPatternTableViewCell.self, data: .pattern($0, card)))
        }
        
        if let unionBurst = card.unionBurst {
            rows.append(Row(type: CDSkillTableViewCell.self, data: .skill(unionBurst, .unionBurst)))
        }
        if let mainSkill1 = card.mainSkill1 {
            rows.append(Row(type: CDSkillTableViewCell.self, data: .skill(mainSkill1, .main)))
        }
        if let mainSkill2 = card.mainSkill2 {
            rows.append(Row(type: CDSkillTableViewCell.self, data: .skill(mainSkill2, .main)))
        }
        if let exSkill1 = card.exSkill1 {
            rows.append(Row(type: CDSkillTableViewCell.self, data: .skill(exSkill1, .ex)))
        }
        if let exSkillEvolution1 = card.exSkillEvolution1 {
            rows.append(Row(type: CDSkillTableViewCell.self, data: .skill(exSkillEvolution1, .exEvolution)))
        }
        
        rows += card.promotions.map { Row(type: CDPromotionTableViewCell.self, data: .promotion($0)) }
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
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            themable.backgroundImageView.image = theme.backgroundImage
            themable.tableView.indicatorStyle = theme.indicatorStyle
        }
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
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
            cell.promotionView.delegate = self
        }
        
        return cell as! UITableViewCell
    }
}

extension CDTableViewController: PromotionViewDelegate {
    
    func promotionView(_ promotionView: PromotionView, didSelectEquipmentID equipmentID: Int) {
        
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
