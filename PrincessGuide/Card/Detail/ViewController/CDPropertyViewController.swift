//
//  CDPropertyViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class CDPropertyViewController: CDTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleSettingsChange(_:)), name: .cardDetailSettingsDidChange, object: nil)
    }
    
    @objc private func handleSettingsChange(_ notification: Notification) {
        reloadAll()
    }
    
    override func prepareRows(for card: Card) {
        rows.removeAll()
        let settings = CDSettingsViewController.Setting.default
        let property = card.property(unitLevel: settings.unitLevel, unitRank: settings.unitRank, bondRank: settings.bondRank, unitRarity: settings.unitRarity)
        let unitLevel = settings.unitLevel
        let targetLevel = settings.targetLevel
        rows += [
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                property.item(for: .atk),
                property.item(for: .magicStr)
                ], unitLevel, targetLevel)),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                property.item(for: .def),
                property.item(for: .magicDef)
                ], unitLevel, targetLevel)),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                property.item(for: .hp),
                property.item(for: .physicalCritical)
                ], unitLevel, targetLevel)),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                property.item(for: .dodge),
                property.item(for: .magicCritical)
                ], unitLevel, targetLevel)),
            Row(type: CDProfileTextTableViewCell.self, data: .textArray(
                [
                    (NSLocalizedString("Swing Time", comment: ""), String(card.base.normalAtkCastTime) + "s"),
                    (NSLocalizedString("Attack Range", comment: ""), String(card.base.searchAreaWidth))
                ]
            )),
            Row(type: CDProfileTextTableViewCell.self, data: .text(NSLocalizedString("Effective Physical HP", comment: ""), String(Int(property.effectivePhysicalHP.rounded())))),
            Row(type: CDProfileTextTableViewCell.self, data: .text(NSLocalizedString("Effective Magical HP", comment: ""), String(Int(property.effectiveMagicalHP.rounded())))),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                property.item(for: .waveHpRecovery)
                ], unitLevel, targetLevel)),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                property.item(for: .waveEnergyRecovery)
                ], unitLevel, targetLevel)),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                property.item(for: .lifeSteal)
                ], unitLevel, targetLevel)),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                property.item(for: .hpRecoveryRate)
                ], unitLevel, targetLevel)),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                property.item(for: .energyRecoveryRate)
                ], unitLevel, targetLevel)),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([
                property.item(for: .energyReduceRate)
                ], unitLevel, targetLevel))
        ]
        
    }

}
