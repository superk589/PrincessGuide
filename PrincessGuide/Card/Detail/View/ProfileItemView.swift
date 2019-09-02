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
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.titleLabel.textColor = theme.color.title
            themeable.contentLabel.textColor = theme.color.body
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
        }
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        titleLabel.adjustsFontSizeToFitWidth = true
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.greaterThanOrEqualTo(titleLabel.snp.bottom)
        }
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
        contentLabel.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel = UILabel()
    
    let contentLabel = UILabel()
    
    func configure(title: String, content: String, colorMode: TextItem.ColorMode) {
        titleLabel.text = title
        contentLabel.text = content
        
        switch colorMode {
        case .down:
            ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
                themeable.contentLabel.textColor = theme.color.downValue
            }
        case .normal:
            ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
                themeable.contentLabel.textColor = theme.color.body
            }
        case .up:
            ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
                themeable.contentLabel.textColor = theme.color.upValue
            }
        }
    }
}
