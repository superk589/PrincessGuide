//
//  CDProfileTextTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class CDProfileTextTableViewCell: UITableViewCell, CardDetailConfigurable {
    
    let titleLabel = UILabel()
    
    let contentLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            themable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themable.backgroundColor = theme.color.tableViewCell.background
            themable.titleLabel.textColor = theme.color.title
            themable.contentLabel.textColor = theme.color.body
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
        }
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        
        contentLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.greaterThanOrEqualTo(titleLabel.snp.bottom)
            make.bottom.equalTo(-10)
            make.right.lessThanOrEqualTo(readableContentGuide)
        }
        contentLabel.numberOfLines = 0
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for item: CardDetailItem) {
        guard case .text(let title, let content) = item else {
            fatalError()
        }
        configure(for: title, content: content)
    }
    
    func configure(for title: String, content: String) {
        titleLabel.text = title
        contentLabel.text = content.replacingOccurrences(of: "\\n", with: "\n")
    }
    
}
