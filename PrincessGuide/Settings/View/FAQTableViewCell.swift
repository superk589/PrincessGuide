//
//  FAQTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/14.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Eureka
import Gestalt

class FAQTableViewCell: UITableViewCell {
    
    let questionLabel = UILabel()
    let answerLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(questionLabel)
        questionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(readableContentGuide)
            make.right.lessThanOrEqualTo(readableContentGuide)
        }
        questionLabel.numberOfLines = 0
        questionLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        
        contentView.addSubview(answerLabel)
        answerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(questionLabel)
            make.right.lessThanOrEqualTo(readableContentGuide)
            make.top.equalTo(questionLabel.snp.bottom).offset(5)
            make.bottom.equalTo(-10)
        }
        answerLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
        answerLabel.numberOfLines = 0
        questionLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        answerLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        questionLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        answerLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.questionLabel.textColor = theme.color.title
            themeable.answerLabel.textColor = theme.color.body
            themeable.backgroundColor = theme.color.tableViewCell.background
        }
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(question: String, answer: String) {
        questionLabel.text = question
        answerLabel.text = answer
    }
    
}
