//
//  CardWithBirthdayCollectionViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class CardWithBirthdayCollectionViewCell: UICollectionViewCell {
    
    let icon = IconImageView()
    
    let birthdayLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        contentView.addSubview(birthdayLabel)
        birthdayLabel.font = UIFont.systemFont(ofSize: 12)
        birthdayLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(icon)
            make.width.lessThanOrEqualTo(icon)
            make.top.equalTo(icon.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.birthdayLabel.textColor = theme.color.body
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for card: Card) {
        icon.cardID = card.iconID()
        let format = NSLocalizedString("%@/%@", comment: "")
        birthdayLabel.text = String(format: format, card.profile.birthMonth, card.profile.birthDay)
    }
}
