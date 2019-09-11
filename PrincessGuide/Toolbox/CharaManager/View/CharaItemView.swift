//
//  CharaItemView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/4.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class CharaItemView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.textColor = Theme.dynamic.color.title
        contentLabel.textColor = Theme.dynamic.color.body
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(5)
            make.firstBaseline.equalTo(titleLabel)
        }
        contentLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel = UILabel()
    
    let contentLabel = UILabel()
    
    func configure(for title: String, content: String) {
        titleLabel.text = title
        contentLabel.text = content
    }
    
}
