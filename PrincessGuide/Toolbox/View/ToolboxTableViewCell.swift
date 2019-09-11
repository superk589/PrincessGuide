//
//  ToolboxTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/6/28.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class ToolboxTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.textColor = Theme.dynamic.color.title
        
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        if #available(iOS 11.0, *) {
            titleLabel.adjustsFontForContentSizeCategory = true
        }
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for title: String) {
        titleLabel.text = title
    }

}
