//
//  VLNoScheduleTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/8/27.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class VLNoScheduleTableViewCell: UITableViewCell {

    let contentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.contentLabel.textColor = theme.color.body
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
        contentLabel.numberOfLines = 0
        contentLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(readableContentGuide)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
        selectionStyle = .none
    }
    
    func configure(for data: VLElement) {
        contentLabel.text = data.content
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
