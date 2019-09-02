//
//  MinionPropertyViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/12/1.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class MinionPropertyViewController: MinionTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleSettingsChange(_:)), name: .cardDetailSettingsDidChange, object: nil)
    }
    
    @objc private func handleSettingsChange(_ notification: Notification) {
        reloadAll()
    }

    override func prepareRows() {
        
        rows.removeAll()
        let settings = CDSettingsViewController.Setting.default
        
        // use skill level as minion's unit level here, not owner's unit level
        let unitLevel = settings.skillLevel
        let targetLevel = settings.targetLevel
        
        let property = minion.property(unitLevel: unitLevel, unitRank: settings.unitRank, bondRank: settings.bondRank, unitRarity: settings.unitRarity, addsEx: settings.addsEx, hasUniqueEquipment: settings.equipsUniqueEquipment, uniqueEquipmentLevel: settings.uniqueEquipmentLevel)
        
        rows += [
            Row.propertyItems([
                property.item(for: .atk),
                property.item(for: .magicStr)
                ], unitLevel, targetLevel),
            Row.propertyItems([
                property.item(for: .def),
                property.item(for: .magicDef)
                ], unitLevel, targetLevel),
            Row.propertyItems([
                property.item(for: .hp),
                property.item(for: .physicalCritical)
                ], unitLevel, targetLevel),
            Row.propertyItems([
                property.item(for: .dodge),
                property.item(for: .magicCritical)
                ], unitLevel, targetLevel),
            Row.textArray(
                [
                    TextItem(title: NSLocalizedString("Swing Time", comment: ""), content: "\(minion.base.normalAtkCastTime)s", colorMode: .normal),
                    TextItem(title: NSLocalizedString("Attack Range", comment: ""), content: String(minion.base.searchAreaWidth), colorMode: .normal)
                ]
            ),
            Row.propertyItems([property.item(for: .accuracy)], unitLevel, targetLevel),
            Row.textArray(
                [
                    TextItem(title: NSLocalizedString("Effective Physical HP", comment: ""), content: String(Int(property.effectivePhysicalHP.rounded())), colorMode: .normal)
                ]
            ),
            Row.textArray(
                [
                    TextItem(title: NSLocalizedString("Effective Magical HP", comment: ""), content: String(Int(property.effectiveMagicalHP.rounded())), colorMode: .normal)
                ]
            ),
            Row.propertyItems([
                property.item(for: .waveHpRecovery)
                ], unitLevel, targetLevel),
            Row.propertyItems([
                property.item(for: .waveEnergyRecovery)
                ], unitLevel, targetLevel),
            Row.propertyItems([
                property.item(for: .lifeSteal)
                ], unitLevel, targetLevel),
            Row.propertyItems([
                property.item(for: .hpRecoveryRate)
                ], unitLevel, targetLevel),
            Row.propertyItems([
                property.item(for: .energyRecoveryRate)
                ], unitLevel, targetLevel),
            Row.propertyItems([
                property.item(for: .energyReduceRate)
                ], unitLevel, targetLevel),
            Row.textArray(
                [
                    TextItem(title: NSLocalizedString("Move Speed", comment: ""), content: String(minion.base.moveSpeed), colorMode: .normal)
                ]
            ),
        ]
        
    }
}
