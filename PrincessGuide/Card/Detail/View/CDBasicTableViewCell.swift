//
//  CDBasicTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import SnapKit
import Reusable

class CDBasicTableViewCell: UITableViewCell, Reusable {
    
    let cardIcon = IconImageView()
    let talentView = UIImageView()
    
    let commentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commentLabel.textColor = Theme.dynamic.color.body
        
        contentView.addSubview(cardIcon)
        cardIcon.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
            make.height.width.equalTo(64)
            make.bottom.lessThanOrEqualTo(-10)
        }
        
        contentView.addSubview(talentView)
        talentView.snp.makeConstraints { make in
            make.right.bottom.equalTo(cardIcon)
            make.size.equalTo(17)
        }
        
        commentLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
        commentLabel.numberOfLines = 0
        contentView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cardIcon.snp.bottom).offset(10)
            make.left.equalTo(readableContentGuide)
            make.right.equalTo(readableContentGuide)
            make.bottom.lessThanOrEqualTo(-10)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(comment: String, iconURL: URL, talentId: Int?) {
        commentLabel.text = comment
        cardIcon.configure(iconURL: iconURL, placeholderStyle: .blank)
        talentView.image = talentId.flatMap { CardTalent(rawValue: $0) }?.image
    }
}
