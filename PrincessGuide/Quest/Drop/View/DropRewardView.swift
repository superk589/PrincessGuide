//
//  DropRewardView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class DropRewardView: UIView {
    
    let itemIcon = IconImageView()
    let countLabel = StrokedTextLabel()
    
    let rateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.rateLabel.textColor = theme.color.caption
            themeable.countLabel.textColor = theme.color.body
        }
        
        addSubview(itemIcon)
        itemIcon.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.height.width.equalTo(64)
        }
        
        addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.bottom.equalTo(itemIcon.snp.bottom).offset(-2)
            make.right.equalTo(itemIcon.snp.right).offset(-2)
        }
        countLabel.font = UIFont.boldSystemFont(ofSize: 12)
        countLabel.textColor = .black
        
        rateLabel.font = UIFont.scaledFont(forTextStyle: .caption1, ofSize: 12)
        addSubview(rateLabel)
        rateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(itemIcon.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    
    func configure(for reward: Drop.Reward, isFocused: Bool = false) {
        rateLabel.text = "\(reward.odds)%"
        invalidateIntrinsicContentSize()
        if reward.rewardType == 4 {
            itemIcon.equipmentID = reward.rewardID
        } else {
            itemIcon.itemID = reward.rewardID
        }
        setHighlighted(isFocused)
        countLabel.text = reward.rewardNum > 1 ? "x\(reward.rewardNum)" : ""
    }
    
    private(set) var isHighlighted: Bool = false
    
    private func setHighlighted(_ isHighlighted: Bool) {
        self.isHighlighted = isHighlighted
        if isHighlighted {
            itemIcon.layer.borderColor = UIColor.red.cgColor
            itemIcon.layer.borderWidth = 2
            itemIcon.layer.cornerRadius = 6
            itemIcon.layer.masksToBounds = true
            ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
                themeable.itemIcon.layer.borderColor = theme.color.highlightedText.cgColor
                themeable.rateLabel.textColor = theme.color.highlightedText
            }
        } else {
            itemIcon.layer.borderWidth = 0
            ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
                themeable.rateLabel.textColor = theme.color.caption
            }
        }
    }
        
    override var intrinsicContentSize: CGSize {
        let rateLabelSize = rateLabel.intrinsicContentSize
        return CGSize(width: 64, height: 64 + rateLabelSize.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
