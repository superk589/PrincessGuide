//
//  MinionTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/12/1.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class MinionTableViewController: UITableViewController {
    
    enum Row {
        case skill(Skill, SkillCategory, Property, Int?)
        case pattern(AttackPattern, Minion, Int?)
        case propertyItems([Property.Item], Int, Int)
        case textArray([TextItem])
    }
    
    let minion: Minion
    
    init(minion: Minion) {
        self.minion = minion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadAll() {
        navigationItem.title = minion.base.unitName
        prepareRows()
        tableView.reloadData()
    }
    
    var rows = [Row]()
    
    func prepareRows() {
        
    }
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.tableView.backgroundColor = theme.color.background
            themeable.tableView.indicatorStyle = theme.indicatorStyle
        }
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.register(cellType: CDProfileTableViewCell.self)
        tableView.register(cellType: CDSkillTableViewCell.self)
        tableView.register(cellType: CDPatternTableViewCell.self)
        tableView.register(cellType: CDBasicTableViewCell.self)
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
        case .pattern(let pattern, let minion, let index):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDPatternTableViewCell.self)
            cell.configure(
                title: index.flatMap { "\(NSLocalizedString("Attack Pattern", comment: "")) \($0)" } ?? NSLocalizedString("Attack Pattern", comment: ""),
                items: pattern.toCollectionViewItems(minion: minion)
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
        case .skill(let skill, let category, let property, let index):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDSkillTableViewCell.self)
            cell.configure(for: skill, category: category, property: property, index: index)
            return cell
        case .textArray(let items):
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CDProfileTableViewCell.self)
            cell.configure(items: items)
            return cell
        }
    }
}
