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
                rows.append(Row.pattern($0.element, enemy, $0.offset + 1))
            }
        } else {
            enemy.patterns?.enumerated().forEach {
                rows.append(Row.pattern($0.element, enemy, nil))
            }
        }
                
        let property = enemy.base.property
        
        if let unionBurstEvolution = enemy.unionBurstEvolution, enemy.base.rarity == 6 {
            rows.append(Row.skill(skill: unionBurstEvolution, category: .unionBurstEvolution, level: enemy.unionBurstSkillLevel, property: property, index: nil))
        } else if let unionBurst = enemy.unionBurst {
            rows.append(Row.skill(skill: unionBurst, category: .unionBurst, level: enemy.unionBurstSkillLevel, property: property, index: nil))
        }
        
        // setup main skills
        if enemy.hasUniqueEquipment {
            rows.append(contentsOf:
                zip(enemy.mainSkillEvolutions, enemy.mainSkills)
                    .enumerated()
                    .map {
                        return Row.skill(skill: $0.element.0, category: .mainEvolution, level: enemy.mainSkillLevel(for: $0.element.1.base.skillId), property: property, index: $0.offset + 1)
                    }
            )
            
            if enemy.mainSkills.count > enemy.mainSkillEvolutions.count {
                rows += enemy.mainSkills[enemy.mainSkillEvolutions.count..<enemy.mainSkills.count]
                    .enumerated()
                    .map {
                        return Row.skill(skill: $0.element, category: .main, level: enemy.mainSkillLevel(for: $0.element.base.skillId), property: property, index: enemy.mainSkillEvolutions.count + $0.offset + 1)
                }
            }
        } else {
            rows.append(contentsOf:
                enemy.mainSkills
                    .enumerated()
                    .map {
                        Row.skill(skill: $0.element, category: .main, level: enemy.mainSkillLevel(for: $0.element.base.skillId), property: property, index: $0.offset + 1)
                }
            )
        }
        
        rows.append(contentsOf:
            enemy.exSkills
                .enumerated()
                .map {
                    Row.skill(skill: $0.element, category: .ex, level: enemy.exSkillLevel(for: $0.element.base.skillId), property: property, index: nil)
            }
        )
        
        // insert minions
        let newRows: [Row] = rows.flatMap { row -> [Row] in
            guard case .skill(let skill, _, _, _, _) = row else {
                return [row]
            }
            let actions = skill.actions
            
            let minions = actions
                .compactMap { $0.parameter as? SummonAction }
                .compactMap { $0.enemyMinion }
                .reduce(into: [Enemy]()) { results, minion in
                    if !results.contains(where: { $0.base.unitId == minion.base.unitId }) {
                        results.append(minion)
                    }
            }
                    
            let rows = minions.map { Row.minion($0) }
            
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

extension AttackPattern {
    
    func toCollectionViewItems(enemy: Enemy) -> [CDPatternTableViewCell.Item] {
        return items.enumerated().map {
            let offset = $0.offset
            let item = $0.element
            let iconType: CDPatternTableViewCell.Item.IconType
            let loopType: CDPatternTableViewCell.Item.LoopType
            let text: String
            switch item {
            case 1:
                if enemy.unit.atkType == 2 {
                    iconType = .magicalSwing
                } else {
                    iconType = .physicalSwing
                }
                text = NSLocalizedString("Swing", comment: "")
            case let x where x > 1000:
                let index = x - 1001
                let skillID = enemy.base.mainSkillIDs[index]
                
                if let (offset, element) = enemy.mainSkills.enumerated().first (where: {
                    $0.element.base.skillId == skillID
                }) {
                    let iconID = element.base.iconType
                    iconType = .skill(iconID)
                    let format = NSLocalizedString("Main %d", comment: "")
                    text = String(format: format, offset + 1)
                } else {
                    iconType = .unknown
                    text = ""
                }
                
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
