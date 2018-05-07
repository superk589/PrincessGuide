//
//  ProfileItemView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class ProfileItemView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            themable.titleLabel.textColor = theme.color.title
            themable.contentLabel.textColor = theme.color.body
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
        }
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.top.greaterThanOrEqualTo(titleLabel.snp.bottom)
        }
        contentLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel = UILabel()
    
    let contentLabel = UILabel()

    func configure(for item: Card.Profile.Item) {
        titleLabel.text = item.key.description
        contentLabel.text = item.value
    }
    
    func configure(for item: Property.Item) {
        titleLabel.text = item.key.description
        if let percent = item.percent, percent != 0 {
            contentLabel.text = String(Int(item.value)) + " (+\(percent)%)"
        } else {
            contentLabel.text = String(Int(item.value))
        }
    }
}
