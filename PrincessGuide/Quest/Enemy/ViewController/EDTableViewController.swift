//
//  EDTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

typealias EnemyDetailItem = EDTableViewController.Row.Model

class EDTableViewController: UITableViewController {
    
    struct Row {
        enum Model {
            case skill(Skill, SkillCategory, Int, Property, Int?)
            case unit(Enemy.Unit)
            case profile(Enemy.Unit)
            case pattern(AttackPattern, Enemy, Int?)
            case minion(Enemy)
            case propertyItems([Property.Item], Int, Int)
            case text(String, String)
            case textArray([(String, String)])
        }
        var type: UITableViewCell.Type
        var data: Model
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
        registerRows()
        tableView.reloadData()
    }
    
    var rows = [Row]()
    
    func prepareRows() {
        
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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView()
        tableView.cellLayoutMarginsFollowReadableWidth = true
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
        let model = rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: model.type.description(), for: indexPath) as! EnemyDetailConfigurable
        cell.configure(for: model.data)
        
        return cell as! UITableViewCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = rows[indexPath.row].data
        switch data {
        case .minion(let minion):
            let vc = EDTabViewController(enemy: minion, isMinion: true)
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}
