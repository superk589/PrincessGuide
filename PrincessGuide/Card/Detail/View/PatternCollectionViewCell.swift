//
//  PatternCollectionViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Kingfisher
import Gestalt

class PatternCollectionViewCell: UICollectionViewCell {
    
    let skillIcon = IconImageView()
    
    let skillLabel = UILabel()
    
    let loopLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.skillLabel.textColor = theme.color.caption
            themeable.loopLabel.textColor = theme.color.caption
        }
        
        contentView.addSubview(skillIcon)
        skillIcon.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(64)
        }
        
        contentView.addSubview(skillLabel)
        skillLabel.font = UIFont.scaledFont(forTextStyle: .caption1, ofSize: 12)
        skillLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(skillIcon.snp.bottom).offset(5)
            make.bottom.lessThanOrEqualTo(-10)
        }
        
        contentView.addSubview(loopLabel)
        loopLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(skillIcon.snp.top).offset(-5)
            make.top.greaterThanOrEqualTo(10)
        }
        loopLabel.font = UIFont.scaledFont(forTextStyle: .caption1, ofSize: 12)
    }
    
    func configure(for pattern: AttackPattern, index: Int, atkType: Int, mainSkills: [Skill]) {
        let item = pattern.items[index]
        switch item {
        case 1:
            if atkType == 2 {
                skillIcon.equipmentID = 101251
            } else {
                skillIcon.equipmentID = 101011                
            }
            skillLabel.text = NSLocalizedString("Swing", comment: "")
        case let x where x > 1000:
            let index = x - 1001
            guard index < mainSkills.count else { fallthrough }
            skillIcon.skillIconID = mainSkills[index].base.iconType
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
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 64, height: 64 + skillLabel.font.lineHeight + loopLabel.font.lineHeight + 30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
