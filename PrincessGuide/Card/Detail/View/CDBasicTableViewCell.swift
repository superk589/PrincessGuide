//
//  CDBasicTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import SnapKit
import Gestalt

typealias CardDetailItem = CDTableViewController.Row.Model

protocol CardDetailConfigurable {
    func configure(for item: CardDetailItem)
}

class CDBasicTableViewCell: UITableViewCell, CardDetailConfigurable {
    
    let cardIcon = IconImageView()
    
    let nameLabel = UILabel()
    
    let commentLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            themable.nameLabel.textColor = theme.color.title
            themable.commentLabel.textColor = theme.color.body
            themable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themable.backgroundColor = theme.color.tableViewCell.background
        }
        
        contentView.addSubview(cardIcon)
        cardIcon.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
            make.height.width.equalTo(64)
        }
        
        nameLabel.font = UIFont.scaledFont(forTextStyle: .title1, ofSize: 16)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(cardIcon.snp.right).offset(10)
            make.top.equalTo(10)
        }
        
        commentLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
        commentLabel.numberOfLines = 0
        contentView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(nameLabel)
            make.right.equalTo(readableContentGuide)
            make.bottom.equalTo(-10)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for base: Card.Base) {
        nameLabel.text = base.unitName
        commentLabel.text = base.comment.replacingOccurrences(of: "\\n", with: "\n")
        cardIcon.cardID = base.unitId
    }
    
    func configure(for profile: Card.Profile) {
        nameLabel.text = profile.unitName
        commentLabel.text = profile.selfText.replacingOccurrences(of: "\\n", with: "\n")
        cardIcon.cardID = profile.unitId
    }
    
    func configure(for item: CardDetailItem) {
        if case .base(let base) = item {
            configure(for: base)
        } else if case .profile(let profile) = item {
            configure(for: profile)
        } else {
            fatalError()
        }
    }
}
