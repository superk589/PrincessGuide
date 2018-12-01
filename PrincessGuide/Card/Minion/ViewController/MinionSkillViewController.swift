//
//  MinionSkillViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/12/1.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class MinionSkillViewController: MinionTableViewController {
    
    override func prepareRows() {
        
        rows.removeAll()
        
        if let patterns = minion.patterns, patterns.count > 1 {
            patterns.enumerated().forEach {
                rows.append(Row(type: CDPatternTableViewCell.self, data: .pattern($0.element, minion, $0.offset + 1)))
            }
        } else {
            minion.patterns?.enumerated().forEach {
                rows.append(Row(type: CDPatternTableViewCell.self, data: .pattern($0.element, minion, nil)))
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
            rows.append(Row(type: CDSkillTableViewCell.self, data: .skill(unionBurst, .unionBurst, property, nil)))
        }
        
        rows.append(contentsOf:
            minion.mainSkills
                .enumerated()
                .map {
                    Row(type: CDSkillTableViewCell.self, data: .skill($0.element, .main, property, $0.offset + 1))
            }
        )
        
        rows.append(contentsOf:
            minion.exSkills
                .enumerated()
                .map {
                    Row(type: CDSkillTableViewCell.self, data: .skill($0.element, .ex, property, $0.offset + 1))
            }
        )
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
}
