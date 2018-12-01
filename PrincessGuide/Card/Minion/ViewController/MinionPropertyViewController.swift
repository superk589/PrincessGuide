//
//  MinionPropertyViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/12/1.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class MinionPropertyViewController: MinionTableViewController {

    override func prepareRows() {
        
        rows.removeAll()
        let settings = CDSettingsViewController.Setting.default
        
        let property = minion.property(unitLevel: settings.unitLevel, unitRank: settings.unitRank, bondRank: settings.bondRank, unitRarity: settings.unitRarity, addsEx: settings.addsEx, hasUniqueEquipment: settings.equipsUniqueEquipment, uniqueEquipmentLevel: settings.uniqueEquipmentLevel)
        
        // use skill level as minion's unit level here, not owner's unit level
        let unitLevel = settings.skillLevel
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
            Row(type: CDProfileTextTableViewCell.self, data:  .textArray(
                [
                    (NSLocalizedString("Swing Time", comment: ""), "\(minion.base.normalAtkCastTime)s"),
                    (NSLocalizedString("Attack Range", comment: ""), String(minion.base.searchAreaWidth))
                ]
                )),
            Row(type: CDProfileTableViewCell.self, data: .propertyItems([property.item(for: .accuracy)], unitLevel, targetLevel)),
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
                ], unitLevel, targetLevel)),
            Row(type: CDProfileTextTableViewCell.self, data: .text(NSLocalizedString("Move Speed", comment: ""), String(minion.base.moveSpeed))),

        ]
        
    }
}
