//
//  BoxTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/5.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt
import Reusable

class BoxTableViewCell: UITableViewCell, Reusable {
    
    let icon = IconImageView()
    
    let nameLabel = UILabel()
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIView()
        multipleSelectionBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
            themeable.multipleSelectionBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.tintColor = theme.color.tint
            themeable.nameLabel.textColor = theme.color.title
        }
        
        contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.greaterThanOrEqualTo(readableContentGuide)
            make.left.greaterThanOrEqualToSuperview().offset(10)
            make.left.equalTo(readableContentGuide).priority(999)
            make.bottom.equalTo(-10)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualTo(readableContentGuide)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(iconURL: URL?, name: String) {
        nameLabel.text = name
        icon.configure(iconURL: iconURL, placeholderStyle: .blank)
    }
}
