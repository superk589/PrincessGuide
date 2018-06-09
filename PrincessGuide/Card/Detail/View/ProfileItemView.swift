//
//  ProfileItemView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class ProfileItemView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.titleLabel.textColor = theme.color.title
            themeable.contentLabel.textColor = theme.color.body
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
        }
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.top.greaterThanOrEqualTo(titleLabel.snp.bottom)
        }
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel = UILabel()
    
    let contentLabel = UILabel()

    func configure(for item: Card.Profile.Item) {
        titleLabel.text = item.key.description
        contentLabel.text = item.value
    }
    
    func configure(for item: Property.Item, unitLevel: Int, targetLevel: Int) {
        titleLabel.text = item.key.description
        if let percent = item.percent(selfLevel: unitLevel, targetLevel: targetLevel), percent != 0 {
            if item.hasLevelAssumption {
                contentLabel.text = String(format: "%d(%.2f%%, %d to %d)", Int(item.value), percent, unitLevel, targetLevel)
            } else {
                contentLabel.text = String(format: "%d(%.2f%%)", Int(item.value), percent)
            }
        } else {
            contentLabel.text = String(Int(item.value))
        }
    }
    
    func configure(for item: Property.Item) {
        titleLabel.text = item.key.description
        contentLabel.text = String(Int(item.value))
    }
    
}
