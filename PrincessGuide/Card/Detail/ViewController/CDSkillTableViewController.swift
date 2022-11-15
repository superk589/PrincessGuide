//
//  CDTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class CDSkillTableViewController: CDTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = true
        NotificationCenter.default.addObserver(self, selector: #selector(handleSettingsChange(_:)), name: .cardDetailSettingsDidChange, object: nil)
    }
    
    @objc private func handleSettingsChange(_ notification: Notification) {
        reloadAll()
    }
    
    override func prepareRows(for card: Card) {
        
        var card = card
        let originalCard = card
        if card.base.conversionId != nil {
            if let conversionUnit = card.conversionUnit {
                card = conversionUnit
            }
        }
        
        let property: Property
        let settings = CDSettingsViewController.Setting.default
        if CDSettingsViewController.Setting.default.expressionStyle == .valueOnly {
            property = card.property(unitLevel: settings.unitLevel, unitRank: settings.unitRank, bondRank: settings.bondRank, unitRarity: settings.unitRarity, addsEx: false, hasUniqueEquipment: settings.equipsUniqueEquipment, uniqueEquipmentLevel: settings.uniqueEquipmentLevel)
        } else if CDSettingsViewController.Setting.default.expressionStyle == .valueInCombat {
            property = card.property(unitLevel: settings.unitLevel, unitRank: settings.unitRank, bondRank: settings.bondRank, unitRarity: settings.unitRarity, addsEx: true, hasUniqueEquipment: settings.equipsUniqueEquipment, uniqueEquipmentLevel: settings.uniqueEquipmentLevel)
        } else {
            property = .zero
        }
        
        rows.removeAll()
        
        if let patterns = card.patterns, patterns.count > 1 {
            card.patterns?.enumerated().forEach {
                rows.append(Row.pattern(pattern: $0.element, card: card, index: $0.offset + 1))
            }
        } else {
            card.patterns?.enumerated().forEach {
                rows.append(Row.pattern(pattern: $0.element, card: card, index: nil))
            }
        }
        
        
        // setup union burst
        
        if settings.skillStyle == .both {
            if let unionBurst = card.unionBurst {
                rows.append(Row.skill(skill: unionBurst, category: .unionBurst, property: property, index: nil))
            }
            if let unionBurstEvolution = card.unionBurstEvolution, settings.unitRarity == 6 {
                rows.append(Row.skill(skill: unionBurstEvolution, category: .unionBurstEvolution, property: property, index: nil))
            }
        } else {
            if let unionBurstEvolution = card.unionBurstEvolution, settings.unitRarity == 6 {
                rows.append(Row.skill(skill: unionBurstEvolution, category: .unionBurstEvolution, property: property, index: nil))
            } else if let unionBurst = card.unionBurst {
                rows.append(Row.skill(skill: unionBurst, category: .unionBurst, property: property, index: nil))
            }
        }
        
        // sp union busrt
        if let spUnionBurst = card.spUnionBurst {
            rows.append(Row.skill(skill: spUnionBurst, category: .spUnionBurst, property: property, index: nil))
        }
        
        // setup main skills
        let hasUniqueEquipments = originalCard.uniqueEquipIDs.count > 0
        if settings.skillStyle == .both && hasUniqueEquipments {
            rows += zip(card.mainSkills, card.mainSkillEvolutions)
                .enumerated()
                .flatMap {
                    [
                        Row.skill(skill: $0.element.0, category: .main, property: property, index: $0.offset + 1),
                        Row.skill(skill: $0.element.1, category: .mainEvolution, property: property, index: $0.offset + 1)
                    ]
                }
            
            if card.mainSkills.count > card.mainSkillEvolutions.count {
                
                rows += card.mainSkills[card.mainSkillEvolutions.count..<card.mainSkills.count]
                    .enumerated()
                    .map {
                        return Row.skill(skill: $0.element, category: .main, property: property, index: card.mainSkillEvolutions.count + $0.offset + 1)
                }
            }
        } else if hasUniqueEquipments {
            rows.append(contentsOf:
                zip(card.mainSkillEvolutions, card.mainSkills)
                    .enumerated()
                    .map {
                        return Row.skill(skill: $0.element.0, category: .mainEvolution, property: property, index: $0.offset + 1)
                }
            )
            
            if card.mainSkills.count > card.mainSkillEvolutions.count {
                
                rows += card.mainSkills[card.mainSkillEvolutions.count..<card.mainSkills.count]
                    .enumerated()
                    .map {
                        return Row.skill(skill: $0.element, category: .main, property: property, index: card.mainSkillEvolutions.count + $0.offset + 1)
                }
            }
        } else {
            rows.append(
                contentsOf: card.mainSkills
                    .enumerated()
                    .map {
                        return Row.skill(skill: $0.element, category: .main, property: property, index: $0.offset + 1)
                    }
            )
        }
        
        // setup sp skills
        if settings.skillStyle == .both {
            rows += zip(card.spSkills, card.spEvolutionsSkills)
                .enumerated()
                .flatMap {
                    [
                        Row.skill(skill: $0.element.0, category: .sp, property: property, index: $0.offset + 1),
                        Row.skill(skill: $0.element.1, category: .spEvolution, property: property, index: $0.offset + 1)
                    ]
            }
            
            if card.spSkills.count > card.spEvolutionsSkills.count {
                rows += card.spSkills[card.spEvolutionsSkills.count..<card.spSkills.count]
                    .enumerated()
                    .map {
                        return Row.skill(skill: $0.element, category: .sp, property: property, index: card.spEvolutionsSkills.count + $0.offset + 1)
                }
            }
        } else {
            rows.append(contentsOf:
                zip(card.spEvolutionsSkills, card.spSkills)
                    .enumerated()
                    .map {
                        return Row.skill(skill: $0.element.0, category: .spEvolution, property: property, index: $0.offset + 1)
                }
            )
            
            if card.spSkills.count > card.spEvolutionsSkills.count {
                rows += card.spSkills[card.spEvolutionsSkills.count..<card.spSkills.count]
                    .enumerated()
                    .map {
                        return Row.skill(skill: $0.element, category: .sp, property: property, index: card.spEvolutionsSkills.count + $0.offset + 1)
                }
            }
        }
        
        // setup ex skills
        if settings.skillStyle == .both {
            rows += zip(card.exSkills, card.exSkillEvolutions)
                .enumerated()
                .flatMap {
                    [
                        Row.skill(skill: $0.element.0, category: .ex, property: property, index: nil),
                        Row.skill(skill: $0.element.1, category: .exEvolution, property: property, index: nil)
                    ]
            }
            
            if card.exSkills.count > card.exSkillEvolutions.count {
                
                rows += card.exSkills[card.exSkillEvolutions.count..<card.exSkills.count]
                    .enumerated()
                    .map {
                        return Row.skill(skill: $0.element, category: .ex, property: property, index: nil)
                }
            }
        } else {
            rows.append(contentsOf:
                zip(card.exSkillEvolutions, card.exSkills)
                    .enumerated()
                    .map {
                        return Row.skill(skill: $0.element.0, category: .exEvolution, property: property, index: nil)
                }
            )
            
            if card.exSkills.count > card.exSkillEvolutions.count {
                
                rows += card.mainSkills[card.exSkillEvolutions.count..<card.exSkills.count]
                    .enumerated()
                    .map {
                        return Row.skill(skill: $0.element, category: .ex, property: property, index: nil)
                }
            }
        }
        
        // insert minions
        let newRows: [Row] = rows.flatMap { row -> [Row] in
            guard case .skill(let skill, _, _, _, _) = row else {
                return [row]
            }
            let actions = skill.actions
            let minions = actions
                .compactMap { $0.parameter as? SummonAction }
                .compactMap { $0.minion }
                .reduce(into: [Minion]()) { results, minion in
                    if !results.contains(where: { $0.base.unitId == minion.base.unitId }) {
                        results.append(minion)
                    }
            }
            let rows = minions.map { Row.minion($0) }
            
            return [row] + rows
        }
        
        // insert rf skills
        if settings.skillLevel > 260 {
            let new: [Row] = newRows.flatMap { row -> [Row] in
                guard case .skill(let skill, let category, let property, let index, _) = row else {
                    return [row]
                }
                if let rfSkill = skill.rfSkill {
                    return [.skill(skill: rfSkill, category: category, property: property, index: index, isRF: true)]
                }
                return [row]
            }
            self.rows = new
        } else {
            self.rows = newRows
        }
    }
    
}

extension AttackPattern {
    
    func toCollectionViewItems(card: Card) -> [CDPatternTableViewCell.Item] {
        return items.enumerated().map {
            let offset = $0.offset
            let item = $0.element
            let iconType: CDPatternTableViewCell.Item.IconType
            let loopType: CDPatternTableViewCell.Item.LoopType
            let text: String
            switch item {
            case 1:
                if card.base.atkType == 2 {
                    iconType = .magicalSwing
                } else {
                    iconType = .physicalSwing
                }
                text = NSLocalizedString("Swing", comment: "")
            case 1000..<2000:
                let index = item - 1001
                let skillID = card.base.mainSkillIDs[index]
                if let iconID = card.mainSkills.first (where: {
                    $0.base.skillId == skillID
                })?.base.iconType {
                    iconType = .skill(iconID)
                } else {
                    iconType = .unknown
                }
                let format = NSLocalizedString("Main %d", comment: "")
                text = String(format: format, index + 1)
            case 2000..<3000:
                let index = item - 2001
                let skillID = card.base.spSkillIDs[index]
                if let iconID = card.spSkills.first (where: {
                    $0.base.skillId == skillID
                })?.base.iconType {
                    iconType = .skill(iconID)
                } else {
                    iconType = .unknown
                }
                let format = NSLocalizedString("SP %d", comment: "")
                text = String(format: format, index + 1)
            default:
                iconType = .unknown
                text = NSLocalizedString("Unknown", comment: "")
            }
            
            switch offset {
            case loopStart - 1:
                if loopStart == loopEnd {
                    loopType = .inPlace
                } else {
                    loopType = .start
                }
            case loopEnd - 1:
                loopType = .end
            default:
                loopType = .none
            }
            
            return CDPatternTableViewCell.Item(
                iconType: iconType,
                loopType: loopType,
                text: text
            )
        }
    }
}
