//
//  MemberView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/12.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class MemberView: UIView {
    
    let icon = IconImageView()
    
    let rarityView = ShadowRarityView()
    
    let uniqueEquipmentView = UIImageView(image: UIImage(named: "unique_equipment"))
    
    let levelLabel = StrokedLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(icon)
        addSubview(rarityView)
        addSubview(levelLabel)
        
        icon.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        rarityView.snp.makeConstraints { (make) in
            make.left.equalTo(2)
            make.bottom.equalTo(-2)
            make.height.lessThanOrEqualTo(10)
            make.right.lessThanOrEqualTo(-2)
        }
        
        levelLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(2)
        }
        
        levelLabel.font = UIFont.boldSystemFont(ofSize: 10)
        levelLabel.textColor = .nearBlack
        
        addSubview(uniqueEquipmentView)
        uniqueEquipmentView.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.size.equalTo(12)
        }
    }
    
    func configure(for member: Member) {
        icon.cardID = member.iconID
        rarityView.setup(stars: Int(member.rarity))
        levelLabel.text = "Lv\(member.level)"
        uniqueEquipmentView.isHidden = !member.enablesUniqueEquipment
    }
    
    func clear() {
        icon.image = nil
        rarityView.setup(stars: 0)
        levelLabel.text = ""
        uniqueEquipmentView.isHidden = true
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 64, height: 64)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
