//
//  EDStatusTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class EDStatusTableViewController: EDTableViewController {
    
    private var isMinion: Bool
    
    init(enemy: Enemy, isMinion: Bool = false) {
        self.isMinion = isMinion
        super.init(enemy: enemy)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleSettingsChange(_:)), name: Notification.Name.enemyDetailSettingsDidChange, object: nil)
    }
    
    override func prepareRows() {
        rows.removeAll()
        let property = enemy.base.property
        let unitLevel = enemy.base.level
        let targetLevel = EDSettingsViewController.Setting.default.targetLevel
        
        if !isMinion {
            rows += [
                Row.unit(enemy.unit),
            ]
        }
        
        rows += [
            Row.textArray([
                TextItem(title: NSLocalizedString("Level", comment: ""), content: String(enemy.base.level), colorMode: .normal)
            ]),
            Row.propertyItems([
                property.item(for: .atk),
                property.item(for: .magicStr)], unitLevel, targetLevel),
            Row.propertyItems([
                property.item(for: .def),
                property.item(for: .magicDef)], unitLevel, targetLevel),
            Row.propertyItems([
                property.item(for: .hp),
                property.item(for: .physicalCritical)], unitLevel, targetLevel),
            Row.propertyItems([
                property.item(for: .dodge),
                property.item(for: .magicCritical)], unitLevel, targetLevel),
            Row.propertyItems([property.item(for: .accuracy)], unitLevel, targetLevel),
            Row.propertyItems([property.item(for: .energyRecoveryRate)], unitLevel, targetLevel),
            Row.propertyItems([property.item(for: .hpRecoveryRate)], unitLevel, targetLevel),
        ]
        rows.append(Row.textArray([
            TextItem(title: NSLocalizedString("Swing Time", comment: ""), content: "\(enemy.unit.normalAtkCastTime)s", colorMode: .normal)
        ]))
        rows.append(Row.textArray([
            TextItem(title: NSLocalizedString("Attack Range", comment: ""), content: "\(enemy.unit.searchAreaWidth)", colorMode: .normal)
        ]))
        rows.append(Row.textArray([
            TextItem(title: NSLocalizedString("Move Speed", comment: ""), content: String(enemy.unit.moveSpeed), colorMode: .normal)
        ]))
    }
    
    @objc private func handleSettingsChange(_ notification: Notification) {
        reloadAll()
    }
    
}
