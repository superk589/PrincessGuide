//
//  EDSkillTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class EDSkillTableViewController: EDTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = true
        NotificationCenter.default.addObserver(self, selector: #selector(handleSettingsChange(_:)), name: Notification.Name.enemyDetailSettingsDidChange, object: nil)
    }

    override func prepareRows() {
        
        rows.removeAll()
        
        
        if let patterns = enemy.patterns, patterns.count > 1 {
            enemy.patterns?.enumerated().forEach {
                rows.append(Row(type: EDPatternTableViewCell.self, data: .pattern($0.element, enemy, $0.offset + 1)))
            }
        } else {
            enemy.patterns?.enumerated().forEach {
                rows.append(Row(type: EDPatternTableViewCell.self, data: .pattern($0.element, enemy, nil)))
            }
        }
                
        let property = enemy.base.property
        
        if let unionBurst = enemy.unionBurst {
            rows.append(Row(type: EDSkillTableViewCell.self, data: .skill(unionBurst, .unionBurst, enemy.base.unionBurstLevel, property, nil)))
        }
        
        rows.append(contentsOf:
            enemy.mainSkills
                .enumerated()
                .map {
                    Row(type: EDSkillTableViewCell.self, data: .skill($0.element, .main, enemy.mainSkillLevel(for: $0.element.base.skillId), property, $0.offset + 1))
            }
        )
        
        rows.append(contentsOf:
            enemy.exSkills
                .enumerated()
                .map {
                    Row(type: EDSkillTableViewCell.self, data: .skill($0.element, .ex, enemy.exSkillLevel(for: $0.element.base.skillId), property, $0.offset + 1))
            }
        )
        
        // insert minions
        let newRows: [Row] = rows.flatMap { row -> [Row] in
            guard case .skill(let skill, _, _, _, _) = row.data else {
                return [row]
            }
            let actions = skill.actions
            let minions = actions.compactMap { $0.parameter as? SummonAction }.compactMap { $0.enemyMinion }
            let rows = minions.map { Row(type: CDMinionTableViewCell.self, data: .minion($0)) }
            
            return [row] + rows
        }
        
        self.rows = newRows
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
    @objc private func handleSettingsChange(_ notification: Notification) {
        reloadAll()
    }

}
