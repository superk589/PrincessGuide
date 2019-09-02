//
//  MinionSkillViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/12/1.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class MinionSkillViewController: MinionTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleSettingsChange(_:)), name: .cardDetailSettingsDidChange, object: nil)
    }
    
    @objc private func handleSettingsChange(_ notification: Notification) {
        reloadAll()
    }
    
    override func prepareRows() {
        
        rows.removeAll()
        
        if let patterns = minion.patterns, patterns.count > 1 {
            patterns.enumerated().forEach {
                rows.append(Row.pattern($0.element, minion, $0.offset + 1))
            }
        } else {
            minion.patterns?.enumerated().forEach {
                rows.append(Row.pattern($0.element, minion, nil))
            }
        }
        
        let property: Property
        let settings = CDSettingsViewController.Setting.default
        if CDSettingsViewController.Setting.default.expressionStyle == .valueOnly {
            property = minion.property(unitLevel: settings.unitLevel, unitRank: settings.unitRank, bondRank: settings.bondRank, unitRarity: settings.unitRarity, addsEx: false)
        } else if CDSettingsViewController.Setting.default.expressionStyle == .valueInCombat {
            property = minion.property(unitLevel: settings.unitLevel, unitRank: settings.unitRank, bondRank: settings.bondRank, unitRarity: settings.unitRarity, addsEx: true)
        } else {
            property = .zero
        }
        
        if let unionBurst = minion.unionBurst {
            rows.append(Row.skill(unionBurst, .unionBurst, property, nil))
        }
        
        rows.append(contentsOf:
            minion.mainSkills
                .enumerated()
                .map {
                    Row.skill($0.element, .main, property, $0.offset + 1)
            }
        )
        
        rows.append(contentsOf:
            minion.exSkills
                .enumerated()
                .map {
                    Row.skill($0.element, .ex, property, $0.offset + 1)
            }
        )
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
}

extension AttackPattern {
    
    func toCollectionViewItems(minion: Minion) -> [CDPatternTableViewCell.Item] {
        return items.enumerated().map {
            let offset = $0.offset
            let item = $0.element
            let iconType: CDPatternTableViewCell.Item.IconType
            let loopType: CDPatternTableViewCell.Item.LoopType
            let text: String
            switch item {
            case 1:
                if minion.base.atkType == 2 {
                    iconType = .magicalSwing
                } else {
                    iconType = .physicalSwing
                }
                text = NSLocalizedString("Swing", comment: "")
            case 1000..<2000:
                let index = item - 1001
                let skillID = minion.base.mainSkillIDs[index]
                if let iconID = minion.mainSkills.first (where: {
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
                let skillID = minion.base.spSkillIDs[index]
                if let iconID = minion.spSkills.first (where: {
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
