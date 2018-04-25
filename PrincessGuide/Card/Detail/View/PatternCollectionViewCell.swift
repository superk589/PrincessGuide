//
//  PatternCollectionViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class PatternCollectionViewCell: UICollectionViewCell {
    
    let skillIcon = IconImageView()
    
    let skillLabel = UILabel()
    
    let loopLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(skillIcon)
        skillIcon.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(64)
        }
        
        contentView.addSubview(skillLabel)
        skillLabel.font = UIFont.scaledFont(forTextStyle: .caption1, ofSize: 12)
        skillLabel.textColor = .darkGray
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
        loopLabel.textColor = .darkGray
    }
    
    func configure(for pattern: AttackPattern, index: Int, unit: Card) {
        let item = pattern.varlidItems[index]
        switch item {
        case 1:
            skillIcon.equipmentID = 101011
            skillLabel.text = NSLocalizedString("Swing", comment: "")
        case 1001:
            skillIcon.skillIconID = unit.mainSkill1?.base.iconType
            skillLabel.text = NSLocalizedString("Main 1", comment: "")
        case 1002:
            skillIcon.skillIconID = unit.mainSkill2?.base.iconType
            skillLabel.text = NSLocalizedString("Main 2", comment: "")
        case 1003:
            skillIcon.skillIconID = unit.mainSkill3?.base.iconType
            skillLabel.text = NSLocalizedString("Main 3", comment: "")
        default:
            skillIcon.showPlaceholder()
            skillLabel.text = NSLocalizedString("Unknown", comment: "")
        }
        
        if pattern.loopStart == index + 1 {
            loopLabel.text = NSLocalizedString("Loop start", comment: "")
        } else if pattern.loopEnd == index + 1 {
            loopLabel.text = NSLocalizedString("Loop end", comment: "")
        } else {
            loopLabel.text = ""
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
