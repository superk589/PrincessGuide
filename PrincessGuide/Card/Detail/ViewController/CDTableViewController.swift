//
//  CDTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class CDTableViewController: UITableViewController {
    
    struct Row {
        enum Model {
            case skill(Skill, SkillCategory)
            case card(Card.Base)
            case pattern(AttackPattern, Card)
            case promotion(Card.Promotion)
        }
        var type: UITableViewCell.Type
        var data: Model
    }
    
    var card: Card? {
        didSet {
            navigationItem.title = card?.base.unitName
            if let card = card {
                prepareRows(for: card)
                tableView.reloadData()
            }
        }
    }
    
    var rows = [Row]()
    
    private func prepareRows(for card: Card) {
        rows.removeAll()
        
        rows.append(Row(type: CDBasicTableViewCell.self, data: .card(card.base)))
        
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
        
        for row in rows {
            tableView.register(row.type.self, forCellReuseIdentifier: row.type.description())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
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
        return cell as! UITableViewCell
    }
}
