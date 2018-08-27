//
//  VLTableViewHeaderFooterView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/8/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class VLTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    let versionLabel = UILabel()
    
    let timeLabel = UILabel()
    
    let backgroundEffectView = UIVisualEffectView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundView = backgroundEffectView
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.backgroundEffectView.effect = UIBlurEffect(style: theme.blurEffectStyle)
            themeable.versionLabel.textColor = theme.color.title
            themeable.timeLabel.textColor = theme.color.lightText
            
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.font = UIFont.scaledFont(forTextStyle: .caption1, ofSize: 12)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.right.lessThanOrEqualTo(readableContentGuide)
            make.top.equalToSuperview()
        }
        
        contentView.addSubview(versionLabel)
        versionLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        versionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.right.lessThanOrEqualTo(readableContentGuide)
            make.top.equalTo(timeLabel.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, subTitle: String) {
        versionLabel.text = title
        timeLabel.text = subTitle
    }

}
