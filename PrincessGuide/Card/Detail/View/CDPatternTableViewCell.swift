//
//  CDPatternTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class CDPatternTableViewCell: UITableViewCell, CardDetailConfigurable {
    
    let titleLabel = UILabel()
    
    let attackPatternView = AttackPatternView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIView()

        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.titleLabel.textColor = theme.color.title
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
        }
        
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(readableContentGuide)
        }
        titleLabel.text = NSLocalizedString("Attack Pattern", comment: "")
        
        contentView.addSubview(attackPatternView)
        attackPatternView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.right.left.equalTo(readableContentGuide)
            make.bottom.equalToSuperview()
        }
        
        selectionStyle = .none
    }
    
    func configure(for item: CardDetailItem) {
        guard case .pattern(let pattern, let card, let index) = item else { return }
        if let index = index {
            titleLabel.text = "\(NSLocalizedString("Attack Pattern", comment: "")) \(index)"
        } else {
            titleLabel.text = NSLocalizedString("Attack Pattern", comment: "")
        }
        let items: [AttackPatternView.Item] = pattern.items.enumerated().map {
            let offset = $0.offset
            let item = $0.element
            let iconType: AttackPatternView.Item.IconType
            let loopType: AttackPatternView.Item.LoopType
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
            
            return AttackPatternView.Item(
                iconType: iconType,
                loopType: loopType,
                text: text
            )
        }
        attackPatternView.configure(for: items)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CDPatternTableViewCell: MinionDetailConfigurable {
    func configure(for item: MinionDetailItem) {
        guard case .pattern(let pattern, let minion, let index) = item else { return }
        if let index = index {
            titleLabel.text = "\(NSLocalizedString("Attack Pattern", comment: "")) \(index)"
        } else {
            titleLabel.text = NSLocalizedString("Attack Pattern", comment: "")
        }
        let items: [AttackPatternView.Item] = pattern.items.enumerated().map {
            let offset = $0.offset
            let item = $0.element
            let iconType: AttackPatternView.Item.IconType
            let loopType: AttackPatternView.Item.LoopType
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
            
            return AttackPatternView.Item(
                iconType: iconType,
                loopType: loopType,
                text: text
            )
        }
        attackPatternView.configure(for: items)
        
    }
}
