//
//  SkillActionValueView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/20.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import SnapKit

class SkillActionValueView: UIView {
    
    let titleLabel = UILabel()
    
    let valueLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 14)
        titleLabel.textColor = .darkGray
        titleLabel.adjustsFontSizeToFitWidth = true
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
        }
        
        valueLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
        valueLabel.textColor = .darkGray
        addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview()
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(5)
        }
        
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        valueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        valueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
