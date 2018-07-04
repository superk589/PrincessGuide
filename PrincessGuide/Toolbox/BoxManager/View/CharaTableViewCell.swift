//
//  CharaTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/2.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class CharaTableViewCell: UITableViewCell {
    
    let charaView = CharaView()
        
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectedBackgroundView = UIView()
        multipleSelectionBackgroundView = UIView()
        preservesSuperviewLayoutMargins = true
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
            themeable.multipleSelectionBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
        }
        
        contentView.addSubview(charaView)
        charaView.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(readableContentGuide)
            make.left.greaterThanOrEqualToSuperview().offset(10)
            make.left.equalTo(readableContentGuide).priority(999)
            make.right.lessThanOrEqualTo(readableContentGuide)
            make.right.lessThanOrEqualToSuperview().offset(-10)
            make.right.equalTo(readableContentGuide).priority(999)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for chara: Chara) {
        charaView.configure(for: chara)
    }
}
