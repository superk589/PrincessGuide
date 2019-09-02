//
//  CDMinionTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/12/1.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt
import Reusable

class CDMinionTableViewCell: UITableViewCell, Reusable {

    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.titleLabel.textColor = theme.color.title
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.center.equalToSuperview()
        }
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        
        accessoryType = .disclosureIndicator
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
