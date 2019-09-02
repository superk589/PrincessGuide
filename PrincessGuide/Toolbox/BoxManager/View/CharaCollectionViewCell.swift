//
//  CharaCollectionViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/5.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class CharaCollectionViewCell: UICollectionViewCell {
    
    let icon = IconImageView()
    
    let rarityView = RarityView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        contentView.addSubview(rarityView)
        rarityView.stackView.alignment = .center
        rarityView.snp.makeConstraints { (make) in
            make.centerX.equalTo(icon)
            make.width.lessThanOrEqualTo(icon)
            make.top.equalTo(icon.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for chara: Chara) {
        icon.configure(iconURL: chara.iconURL, placeholderStyle: .blank)
        rarityView.setup(stars: Int(chara.rarity))
    }
}
