//
//  QuestEnemyTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/9.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class QuestEnemyTableViewController: UITableViewController {
    
    struct Row {
        var type: UITableViewCell.Type
        var data: Model
        
        enum Model {
            case quest(String)
            case wave(Wave, Int)
            case clanBattleWave(Wave, Int, Double)
            case tower([Enemy], Int)
        }
    }

    var rows: [Row]
    
    init(quests: [Quest]) {
        self.rows = quests.flatMap {
            [Row(type: QuestNameTableViewCell.self, data: .quest($0.base.questName))] +
                $0.waves.enumerated().map{ Row(type: QuestEnemyTableViewCell.self, data: .wave($0.element, $0.offset)) }
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    init(clanBattle: ClanBattle) {
        self.rows = clanBattle.rounds.flatMap {
            [Row(type: QuestNameTableViewCell.self, data: .quest($0.name))] +
                $0.groups.enumerated().map{ Row(type: QuestEnemyTableViewCell.self, data: .clanBattleWave($0.element.wave, $0.offset, $0.element.scoreCoefficient)) }
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    init(towerQuests: [Tower.Quest]) {
        self.rows = towerQuests.map {
            Row(type: QuestEnemyTableViewCell.self, data: .tower($0.enemies, $0.floorNum))
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.backgroundImageView.image = theme.backgroundImage
            themeable.tableView.indicatorStyle = theme.indicatorStyle
            themeable.tableView.backgroundColor = theme.color.background
        }
        
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableView.automaticDimension
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.register(QuestEnemyTableViewCell.self, forCellReuseIdentifier: QuestEnemyTableViewCell.description())
        tableView.register(QuestNameTableViewCell.self, forCellReuseIdentifier: QuestNameTableViewCell.description())
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] (context) in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
        }, completion: nil)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.type.description(), for: indexPath)
        
        switch (cell, row.data) {
        case (let cell as QuestEnemyTableViewCell, .wave(let wave, let index)):
            cell.delegate = self
            let format = NSLocalizedString("Wave %d", comment: "")
            let title = String(format: format, index + 1)
            cell.configure(for: wave, title: title)
        case (let cell as QuestEnemyTableViewCell, .clanBattleWave(let wave, let index, let coefficient)):
            cell.delegate = self
            let format = NSLocalizedString("Wave %d (x%.2f)", comment: "")
            let title = String(format: format, index + 1, coefficient)
            cell.configure(for: wave, title: title)
        case (let cell as QuestNameTableViewCell, .quest(let name)):
            cell.configure(for: name)
        case (let cell as QuestEnemyTableViewCell, .tower(let enemies, let floor)):
            cell.configure(for: enemies, title: String(floor))
            cell.delegate = self
        default:
            break
        }
        return cell
    }
    
}

extension QuestEnemyTableViewController: QuestEnemyTableViewCellDelegate {
    
    func questEnemyTableViewCell(_ questEnemyTableViewCell: QuestEnemyTableViewCell, didSelect enemy: Enemy) {
        let vc = EDTabViewController(enemy: enemy)
        navigationController?.pushViewController(vc, animated: true)
    }
}
