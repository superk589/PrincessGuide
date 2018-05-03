//
//  PromotionCollectionViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/3.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class PromotionCollectionViewCell: UICollectionViewCell {
    
    let icon = IconImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(64)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 64, height: 64)
    }
    
    func configure(for equipmentID: Int) {
        icon.equipmentID = equipmentID
    }
}
