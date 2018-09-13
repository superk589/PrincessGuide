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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.nameLabel.textColor = theme.color.title
            themeable.commentLabel.textColor = theme.color.body
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
        }
        
        contentView.addSubview(cardIcon)
        cardIcon.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
            make.height.width.equalTo(64)
            make.bottom.lessThanOrEqualTo(-10)
        }
        
        nameLabel.font = UIFont.scaledFont(forTextStyle: .title1, ofSize: 16)
//        contentView.addSubview(nameLabel)
//        nameLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(cardIcon.snp.right).offset(10)
//            make.top.equalTo(10)
//        }
        
        commentLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
        commentLabel.numberOfLines = 0
        contentView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(cardIcon.snp.right).offset(10)
            make.right.equalTo(readableContentGuide)
            make.bottom.lessThanOrEqualTo(-10)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for card: Card) {
        nameLabel.text = card.base.unitName
        commentLabel.text = card.base.comment.replacingOccurrences(of: "\\n", with: "\n")
        cardIcon.cardID = card.iconID()
    }
    
    func configure(for item: CardDetailItem) {
        if case .card(let card) = item {
            configure(for: card)
        } else {
            fatalError()
        }
    }
}
