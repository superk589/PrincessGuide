//
//  EDTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class EDTableViewController: UITableViewController {
    
    enum Row {
        case skill(skill: Skill, category: SkillCategory, level: Int, property: Property, ownerProperty: Property?, index: Int?)
        case unit(Enemy.Unit)
        case pattern(AttackPattern, Enemy, Int?)
        case minion(Enemy)
        case propertyItems([Property.Item], Int, Int)
        case textArray([TextItem])
    }
    
    let enemy: Enemy
    
    init(enemy: Enemy) {
        self.enemy = enemy
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadAll() {
        navigationItem.title = enemy.base.name
        prepareRows()
        tableView.reloadData()
    }
    
    var rows = [Row]()
    
    func prepareRows() {
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.register(cellType: EDPropertyTableViewCell.self)
        tableView.register(cellType: EDPatternTableViewCell.self)
        tableView.register(cellType: EDSkillTableViewCell.self)
        tableView.register(cellType: EDBasicTableViewCell.self)
        tableView.register(cellType: CDMinionTableViewCell.self)
        reloadAll()
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
        let row = rows[indexPath.row]
        switch row {
        case .minion(let minion):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDMinionTableViewCell.self)
            let format = NSLocalizedString("Minion: %d(Unit: %d)", comment: "")
            cell.configure(title: String(format: format, minion.base.enemyId, minion.unit.prefabId))
            return cell
        case .pattern(let pattern, let enemy, let index):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: EDPatternTableViewCell.self)
            cell.configure(
                title: index.flatMap { "\(NSLocalizedString("Attack Pattern", comment: "")) \($0)" } ?? NSLocalizedString("Attack Pattern", comment: ""),
                items: pattern.toCollectionViewItems(enemy: enemy)
            )
            return cell
        case .propertyItems(let items, let unitLevel, let targetLevel):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDProfileTableViewCell.self)
            cell.configure(items: items.map {
                let content: String
                if let percent = $0.percent(selfLevel: unitLevel, targetLevel: targetLevel), percent != 0 {
                    if $0.hasLevelAssumption {
                        content = String(format: "%d(%.2f%%, %d to %d)", Int($0.value), percent, unitLevel, targetLevel)
                    } else {
                        content = String(format: "%d(%.2f%%)", Int($0.value), percent)
                    }
                } else {
                    content = String(Int($0.value))
                }
                return TextItem(
                    title: $0.key.description,
                    content: content,
                    colorMode: .normal
                )
            })
            return cell
        case .skill(let skill, let category, let level, let property, let ownerProperty, let index):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: EDSkillTableViewCell.self)
            cell.configure(for: skill, category: category, level: level, property: property, ownerPropery: ownerProperty, index: index)
            return cell
        case .textArray(let items):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDProfileTableViewCell.self)
            cell.configure(items: items)
            return cell
        case .unit(let unit):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: EDBasicTableViewCell.self)
            cell.configure(
                comment: unit.comment.replacingOccurrences(of: "\\n", with: "\n"),
                iconURL: unit.iconURL,
                talentId: nil
            )
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = rows[indexPath.row]
        switch row {
        case .minion(let minion):
            let vc = EDTabViewController(enemy: minion, isMinion: true)
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
