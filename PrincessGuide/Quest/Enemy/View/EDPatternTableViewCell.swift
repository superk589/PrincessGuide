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
        case let x where x > 1000:
            let index = x - 1001
            guard index < enemy.mainSkills.count else { fallthrough }
            skillIcon.skillIconID = enemy.mainSkills[index].base.iconType
            let format = NSLocalizedString("Main %d", comment: "")
            skillLabel.text = String(format: format, index + 1)
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
    
    func configure(for items: [Item], index: Int?) {
        self.items = items
        collectionView.reloadData()
        layoutIfNeeded()
        if let index = index {
            titleLabel.text = "\(NSLocalizedString("Attack Pattern", comment: "")) \(index)"
        } else {
            titleLabel.text = NSLocalizedString("Attack Pattern", comment: "")
        }
    }
    
    func configure(for item: EDTableViewController.Row.Model) {
        guard case .pattern(let pattern, let enemy, let index) = item else {
            fatalError()
        }
        
        let items: [Item] = pattern.items.enumerated().map {
            let offset = $0.offset
            let item = $0.element
            let iconType: Item.IconType
            let loopType: Item.LoopType
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
            case pattern.loopStart - 1:
                if pattern.loopStart == pattern.loopEnd {
                    loopType = .inPlace
                } else {
                    loopType = .start
                }
            case pattern.loopEnd - 1:
                loopType = .end
            default:
                loopType = .none
            }
            
            return Item(
                iconType: iconType,
                loopType: loopType,
                text: text
            )
        }
        
        configure(for: items, index: index)
    }
}

