//
//  SkillActionView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/20.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class SkillActionView: UIView {
    
    let valueLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            themable.valueLabel.textColor = theme.color.body
        }
        
        valueLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
        valueLabel.numberOfLines = 0
        addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    func configure(for action: Skill.Action) {
        valueLabel.text = "- \(action.detail)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
