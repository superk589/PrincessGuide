//
//  CardCollectionViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    var isEnable = true {
        didSet {
            if isEnable {
                foregroundView.alpha = 0
            } else {
                foregroundView.alpha = 0.55
            }
        }
    }
    
    let icon = IconImageView()
    let talentView = UIImageView()
    
    let foregroundView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        foregroundView.backgroundColor = Theme.dynamic.color.foregroundColor
        
        contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(talentView)
        talentView.snp.makeConstraints { make in
            make.bottom.right.equalTo(icon)
            make.size.equalTo(17)
        }
        
        contentView.addSubview(foregroundView)
        foregroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        foregroundView.alpha = 0
        foregroundView.isUserInteractionEnabled = false
        
    }
    
    func configure(for card: Card, isEnable: Bool) {
        icon.configure(iconURL: card.iconURL(), placeholderStyle: .blank)
        talentView.image = card.base.talentId.flatMap { CardTalent(rawValue: $0) }?.image
        self.isEnable = isEnable
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
