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
        
        let property: Property
        let combatEffectiveness: Int
        
        if settings.statusComparison {
            let fromProperty = card.property(unitLevel: settings.unitLevel, unitRank: settings.rankFrom, bondRank: settings.bondRank, unitRarity: settings.unitRarity, addsEx: settings.addsEx, hasUniqueEquipment: settings.equipsUniqueEquipment, uniqueEquipmentLevel: settings.uniqueEquipmentLevel)
            let toProperty = card.property(unitLevel: settings.unitLevel, unitRank: settings.rankTo, bondRank: settings.bondRank, unitRarity: settings.unitRarity, addsEx: settings.addsEx, hasUniqueEquipment: settings.equipsUniqueEquipment, uniqueEquipmentLevel: settings.uniqueEquipmentLevel)
            property = toProperty - fromProperty
            
            let fromCombatEffectiveness = card.combatEffectiveness(unitLevel: settings.unitLevel, unitRank: settings.rankFrom, bondRank: settings.bondRank, unitRarity: settings.unitRarity, skillLevel: settings.skillLevel, hasUniqueEquipment: settings.equipsUniqueEquipment, uniqueEquipmentLevel: settings.uniqueEquipmentLevel)
            let toCombatEffectiveness = card.combatEffectiveness(unitLevel: settings.unitLevel, unitRank: settings.rankTo, bondRank: settings.bondRank, unitRarity: settings.unitRarity, skillLevel: settings.skillLevel, hasUniqueEquipment: settings.equipsUniqueEquipment, uniqueEquipmentLevel: settings.uniqueEquipmentLevel)
            combatEffectiveness = toCombatEffectiveness - fromCombatEffectiveness
        } else {
            property = card.property(unitLevel: settings.unitLevel, unitRank: settings.unitRank, bondRank: settings.bondRank, unitRarity: settings.unitRarity, addsEx: settings.addsEx, hasUniqueEquipment: settings.equipsUniqueEquipment, uniqueEquipmentLevel: settings.uniqueEquipmentLevel)
            combatEffectiveness = card.combatEffectiveness(unitLevel: settings.unitLevel, unitRank: settings.unitRank, bondRank: settings.bondRank, unitRarity: settings.unitRarity, skillLevel: settings.skillLevel, hasUniqueEquipment: settings.equipsUniqueEquipment, uniqueEquipmentLevel: settings.uniqueEquipmentLevel)
        }
        
        let unitLevel = settings.unitLevel
        let targetLevel = settings.targetLevel
        
        rows += [
            
            Row.textArray([
                TextItem(title: NSLocalizedString("Combat Effectiveness", comment: ""), content: String(combatEffectiveness), deltaValue: settings.statusComparison ? combatEffectiveness : 0)
                ]),
            Row.propertyItems(items: [
                property.item(for: .atk),
                property.item(for: .magicStr)
                ], unitLevel: unitLevel, targetLevel: targetLevel, enablesComparisonMode: settings.statusComparison),
            Row.propertyItems(items: [
                property.item(for: .def),
                property.item(for: .magicDef)
                ], unitLevel: unitLevel, targetLevel: targetLevel, enablesComparisonMode: settings.statusComparison),
            Row.propertyItems(items: [
                property.item(for: .hp),
                property.item(for: .physicalCritical)
                ], unitLevel: unitLevel, targetLevel: targetLevel, enablesComparisonMode: settings.statusComparison),
            Row.propertyItems(items: [
                property.item(for: .dodge),
                property.item(for: .magicCritical)
                ], unitLevel: unitLevel, targetLevel: targetLevel, enablesComparisonMode: settings.statusComparison),
            Row.textArray(
                [
                    TextItem(title: NSLocalizedString("Swing Time", comment: ""), content: String(card.base.normalAtkCastTime) + "s", colorMode: .normal),
                    TextItem(title: NSLocalizedString("Attack Range", comment: ""), content: String(card.base.searchAreaWidth), colorMode: .normal)
                ]),
            Row.textArray(
                [
                    TextItem(title: NSLocalizedString("Effective Physical HP", comment: ""), content: String(Int(property.effectivePhysicalHP.rounded())), deltaValue: settings.statusComparison ? property.effectivePhysicalHP.rounded() : 0),
                    TextItem(title: NSLocalizedString("Effective Magical HP", comment: ""), content: String(Int(property.effectiveMagicalHP.rounded())), deltaValue: settings.statusComparison ? property.effectiveMagicalHP.rounded() : 0)
                ]),
            Row.propertyItems(items: [
                property.item(for: .hpRecoveryRate),
                property.item(for: .lifeSteal)
                ], unitLevel: unitLevel, targetLevel: targetLevel, enablesComparisonMode: settings.statusComparison),
            Row.propertyItems(items: [
                property.item(for: .energyRecoveryRate),
                property.item(for: .energyReduceRate)
                ], unitLevel: unitLevel, targetLevel: targetLevel, enablesComparisonMode: settings.statusComparison),
            Row.propertyItems(items: [
                property.item(for: .waveHpRecovery),
                property.item(for: .waveEnergyRecovery)
                ], unitLevel: unitLevel, targetLevel: targetLevel, enablesComparisonMode: settings.statusComparison),
            Row.textArray(
                [
                    TextItem(title: PropertyKey.accuracy.description, content: String(Int(property.accuracy.rounded())), deltaValue: settings.statusComparison ? property.accuracy.rounded() : 0),
                    TextItem(title: NSLocalizedString("Move Speed", comment: ""), content: String(card.base.moveSpeed), colorMode: .normal)
                ])
        ]
        
    }
    
}
