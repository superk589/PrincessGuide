//
//  CraftTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/3.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class CraftTableViewCell: UITableViewCell, CraftDetailConfigurable {
    
    let icon = IconImageView()
    
    let nameLabel = UILabel()
    
    let consumeNumberLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.nameLabel.textColor = theme.color.title
            themeable.consumeNumberLabel.textColor = theme.color.body
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
        }
        
        contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        nameLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        
        contentView.addSubview(consumeNumberLabel)
        consumeNumberLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        consumeNumberLabel.snp.makeConstraints { (make) in
            make.right.equalTo(readableContentGuide)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(for consume: Craft.Consume) {
        nameLabel.text = consume.equipment?.equipmentName
        consumeNumberLabel.text = String(consume.consumeNum)
        icon.equipmentID = consume.equipmentID
    }
    
    func configure(for item: CraftDetailItem) {
        guard case .consume(let consume) = item else {
            fatalError()
        }
        configure(for: consume)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
