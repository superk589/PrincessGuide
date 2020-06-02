//
//  HomeCardCollectionViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 6/2/20.
//  Copyright © 2020 zzk. All rights reserved.
//

import UIKit
import Reusable

class HomeCardCollectionViewCell: UICollectionViewCell, Reusable {

    let icon = IconImageView()
    let rarityView = RarityView()
    let bottomLabel = UILabel()
    
    typealias Mode = CardView.Mode
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(rarityView)
        contentView.addSubview(icon)
        contentView.addSubview(bottomLabel)
        
        icon.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.size.equalTo(64)
        }
                
        rarityView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(icon.snp.bottom).offset(5)
            make.height.equalTo(16)
        }
        
        bottomLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(icon.snp.bottom).offset(5)
            make.left.greaterThanOrEqualToSuperview()
        }
        bottomLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
        bottomLabel.isHidden = true
        
        bottomLabel.adjustsFontForContentSizeCategory = true
        bottomLabel.adjustsFontSizeToFitWidth = true
        bottomLabel.textColor = Theme.dynamic.color.body
    }
    
    func configure(for card: Card, value: String?, mode: Mode = .rarity) {
        rarityView.setup(stars: card.base.rarity)
        icon.cardID = card.iconID()
        bottomLabel.text = value
        bottomLabel.isHidden = mode == .rarity
        rarityView.isHidden = mode == .text
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 64, height: UIView.noIntrinsicMetric)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
