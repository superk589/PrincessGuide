//
//  QuestAreaTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class QuestAreaTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel()
    
    let typeLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            themable.titleLabel.textColor = theme.color.title
            themable.typeLabel.textColor = theme.color.lightText
            themable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themable.backgroundColor = theme.color.tableViewCell.background
        }
        
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.centerY.equalToSuperview()
        }
        
//        typeLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
//        contentView.addSubview(typeLabel)
//        typeLabel.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.right.equalTo(readableContentGuide)
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for area: Area) {
        titleLabel.text = area.areaName
        typeLabel.text = area.areaType.description
    }
}
