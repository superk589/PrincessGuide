//
//  ImageCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/3.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Eureka
import Gestalt

class ImageCell: Cell<String>, CellType {
    
    let titleLabel = UILabel()
    
    let icon = IconImageView()
    
    override func setup() {
        super.setup()
        
        selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.titleLabel.textColor = theme.color.title
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
        }
        
        contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(readableContentGuide)
            make.bottom.equalTo(-10)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        
        selectionStyle = .none
        
    }
    
    func configure(for card: Card) {
        titleLabel.text = card.base.unitName
        icon.cardID = card.iconID()
    }
    
    public override func update() {
        super.update()
        detailTextLabel?.text = ""
    }
}

final class ImageRow: Row<ImageCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}
