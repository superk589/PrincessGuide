//
//  EDStatusTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class EDStatusTableViewController: EDTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleSettingsChange(_:)), name: Notification.Name.enemyDetailSettingsDidChange, object: nil)
    }
    
    override func prepareRows() {
        rows.removeAll()
        let property = enemy.base.property
        let unitLevel = enemy.base.level
        let targetLevel = EDSettingsViewController.Setting.default.targetLevel
        rows += [
            Row(type: EDBasicTableViewCell.self, data: .unit(enemy.unit)),
            Row(type: EDProfileTextTableViewCell.self, data: .text(NSLocalizedString("Level", comment: ""), String(enemy.base.level))),
            Row(type: EDPropertyTableViewCell.self, data: .propertyItems([property.item(for: .atk),
                                                                          property.item(for: .magicStr)], unitLevel, targetLevel)),
            Row(type: EDPropertyTableViewCell.self, data: .propertyItems([property.item(for: .def),
                                                                          property.item(for: .magicDef)], unitLevel, targetLevel)),
            Row(type: EDPropertyTableViewCell.self, data: .propertyItems([property.item(for: .hp),
                                                                          property.item(for: .physicalCritical)], unitLevel, targetLevel)),
            Row(type: EDPropertyTableViewCell.self, data: .propertyItems([property.item(for: .dodge),
                                                                          property.item(for: .magicCritical)], unitLevel, targetLevel)),
            Row(type: EDPropertyTableViewCell.self, data: .propertyItems([property.item(for: .accuracy)], unitLevel, targetLevel)),
            Row(type: EDPropertyTableViewCell.self, data: .propertyItems([property.item(for: .energyRecoveryRate)], unitLevel, targetLevel)),
            Row(type: EDPropertyTableViewCell.self, data: .propertyItems([property.item(for: .hpRecoveryRate)], unitLevel, targetLevel)),
        ]
        
        rows.append(Row(type: EDProfileTextTableViewCell.self, data: .text(NSLocalizedString("Swing Time", comment: ""), "\(enemy.unit.normalAtkCastTime)s")))
        rows.append(Row(type: EDProfileTextTableViewCell.self, data: .text(NSLocalizedString("Attack Range", comment: ""), "\(enemy.unit.searchAreaWidth)")))
    }
    
    @objc private func handleSettingsChange(_ notification: Notification) {
        reloadAll()
    }
    
}
