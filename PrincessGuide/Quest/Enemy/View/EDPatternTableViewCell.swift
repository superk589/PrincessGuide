//
//  EDPatternTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

typealias EDPatternTableViewCell = CDPatternTableViewCell

extension PatternCollectionViewCell {
    func configure(for pattern: AttackPattern, index: Int, enemy: Enemy) {
        let item = pattern.items[index]
        switch item {
        case 1:
            if enemy.unit.atkType == 2 {
                skillIcon.equipmentID = 101251
            } else {
                skillIcon.equipmentID = 101011
            }
            skillLabel.text = NSLocalizedString("Swing", comment: "")
        case 1001:
            skillIcon.skillIconID = enemy.mainSkill1?.base.iconType
            skillLabel.text = NSLocalizedString("Main 1", comment: "")
        case 1002:
            skillIcon.skillIconID = enemy.mainSkill2?.base.iconType
            skillLabel.text = NSLocalizedString("Main 2", comment: "")
        case 1003:
            skillIcon.skillIconID = enemy.mainSkill3?.base.iconType
            skillLabel.text = NSLocalizedString("Main 3", comment: "")
        default:
            skillIcon.image = #imageLiteral(resourceName: "icon_placeholder")
            skillLabel.text = NSLocalizedString("Unknown", comment: "")
        }
        
        if pattern.loopStart == index + 1 {
            if pattern.loopStart == pattern.loopEnd {
                loopLabel.text = NSLocalizedString("Loop in place", comment: "")
            } else {
                loopLabel.text = NSLocalizedString("Loop start", comment: "")
            }
        } else if pattern.loopEnd == index + 1 {
            loopLabel.text = NSLocalizedString("Loop end", comment: "")
        } else {
            loopLabel.text = ""
        }
    }
}

extension EDPatternTableViewCell: EnemyDetailConfigurable {
    
    func configure(for pattern: AttackPattern, enemy: Enemy) {
        attackPatternView.configure(for: pattern, enemy: enemy)
    }
    
    func configure(for item: EDTableViewController.Row.Model) {
        guard case .pattern(let pattern, let enemy) = item else {
            fatalError()
        }
        configure(for: pattern, enemy: enemy)
    }
}

