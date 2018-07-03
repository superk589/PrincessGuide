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
    
    let icon = IconImageView()
    
    let nameLabel = UILabel()
    
    var card: Card?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
            themeable.nameLabel.textColor = theme.color.title
        }
        
        contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(10)
            make.top.equalTo(icon.snp.top)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for chara: Chara) {
        card = DispatchSemaphore.sync { (closure) in
            Master.shared.getCards(cardID: Int(chara.id), callback: closure)
        }?.first
        
        nameLabel.text = card?.base.unitName
        if let iconID = card?.iconID {
            icon.unitID = iconID
        }
        
        
    }
}
