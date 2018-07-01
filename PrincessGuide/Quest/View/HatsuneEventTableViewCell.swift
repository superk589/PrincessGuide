//
//  HatsuneEventTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/17.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class HatsuneEventTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    
    let subtitleLabel = UILabel()
    
    let icon = IconImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.titleLabel.textColor = theme.color.title
            themeable.subtitleLabel.textColor = theme.color.lightText
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
        }
        
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        if #available(iOS 11.0, *) {
            titleLabel.adjustsFontForContentSizeCategory = true
            subtitleLabel.adjustsFontForContentSizeCategory = true
        }
        
        contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualTo(readableContentGuide)
        }
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(10)
            make.bottom.equalTo(titleLabel.snp.top)
            make.right.lessThanOrEqualTo(readableContentGuide)
        }
        subtitleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 14)
        
        icon.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        subtitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for title: String, subtitle: String, unitID: Int?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        icon.unitID = unitID
    }

}
