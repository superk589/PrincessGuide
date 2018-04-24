//
//  CDBasicTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import SnapKit

typealias CardDetailItem = CDTableViewController.Row.Data

protocol CardDetailConfigurable {
    func configure(for item: CardDetailItem)
}

class CDBasicTableViewCell: UITableViewCell, CardDetailConfigurable {
    
    let nameLabel = UILabel()
    
    let commentLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        nameLabel.font = UIFont.scaledFont(forTextStyle: .title1, ofSize: 16)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
        }
        
        commentLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
        commentLabel.numberOfLines = 0
        contentView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
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
    }
    
    func configure(for item: CardDetailItem) {
        guard case .card(let base) = item else { return }
        configure(for: base)
    }
}
