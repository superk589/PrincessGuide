//
//  EquipmentCollectionViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/27.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class EquipmentCollectionViewCell: UICollectionViewCell {
    
    let equipmentIcon = IconImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(equipmentIcon)
        equipmentIcon.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(for equipment: Equipment) {
        equipmentIcon.equipmentID = equipment.equipmentId
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
