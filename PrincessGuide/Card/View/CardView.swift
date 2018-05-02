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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameLabel)
        addSubview(rarityView)
        addSubview(icon)
        
        icon.snp.makeConstraints { (make) in
            make.height.equalTo(64)
            make.width.equalTo(64)
            make.left.top.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(icon.snp.right).offset(10)
        }
        
        rarityView.snp.makeConstraints { (make) in
            make.right.centerY.equalToSuperview()
        }
        
        nameLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
    }
    
    func configure(for card: Card) {
        nameLabel.text = card.base.unitName
        rarityView.setup(stars: card.base.rarity)
        icon.cardID = card.base.unitId
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 64)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
