//
//  CardView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/10.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class CardView: UIView {
    
    let icon = IconImageView()
    let nameLabel = UILabel()
    let rarityView = RarityView()
    let rightLabel = UILabel()
    
    enum Mode {
        case rarity
        case text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameLabel)
        addSubview(rarityView)
        addSubview(icon)
        addSubview(rightLabel)
        
        icon.snp.makeConstraints { (make) in
            make.height.equalTo(64)
            make.width.equalTo(64)
            make.left.top.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(icon.snp.right).offset(10)
        }
        nameLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        
        rarityView.snp.makeConstraints { (make) in
            make.right.centerY.equalToSuperview()
        }
        
        rightLabel.snp.makeConstraints { (make) in
            make.right.centerY.equalToSuperview()
        }
        rightLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
        rightLabel.isHidden = true
        
        if #available(iOS 11.0, *) {
            nameLabel.adjustsFontForContentSizeCategory = true
            rightLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    func configure(for card: Card, value: String?, mode: Mode = .rarity) {
        nameLabel.text = card.base.unitName
        rarityView.setup(stars: card.base.rarity)
        icon.cardID = card.iconID
        rightLabel.text = value
        rightLabel.isHidden = mode == .rarity
        rarityView.isHidden = mode == .text
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 64)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
