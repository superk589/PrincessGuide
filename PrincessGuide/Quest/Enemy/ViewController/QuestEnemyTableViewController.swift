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
    
    let backgroundImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = backgroundImageView
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            themable.backgroundImageView.image = theme.backgroundImage
            themable.tableView.indicatorStyle = theme.indicatorStyle
        }
        
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(QuestEnemyTableViewCell.self, forCellReuseIdentifier: QuestEnemyTableViewCell.description())
        tableView.register(QuestNameTableViewCell.self, forCellReuseIdentifier: QuestNameTableViewCell.description())
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
            cell.configure(for: wave, index: index)
        case (let cell as QuestNameTableViewCell, .quest(let name)):
            cell.configure(for: name)
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
