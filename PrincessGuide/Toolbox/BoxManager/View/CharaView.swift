//
//  CharaView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/3.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class CharaView: UIView {

    let icon = IconImageView()
    
    let rarityView = RarityView()
    
    let bondRankView = CharaItemView()
    
    let rankView = CharaItemView()
    
    let levelView = CharaItemView()
    
    let skillLevelView = CharaItemView()
    
    var icons = [SelectableIconImageView]()
    
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        addSubview(rarityView)
        rarityView.stackView.alignment = .center
        rarityView.snp.makeConstraints { (make) in
            make.centerX.equalTo(icon)
            make.width.lessThanOrEqualTo(icon)
            make.top.equalTo(icon.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
        }
        
        addSubview(levelView)
        levelView.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(10)
            make.top.equalToSuperview()
        }
        
        addSubview(bondRankView)
        bondRankView.snp.makeConstraints { (make) in
            make.left.equalTo(levelView.snp.right)
            make.right.equalToSuperview()
            make.width.top.equalTo(levelView)
        }
        
        addSubview(rankView)
        rankView.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(10)
            make.top.equalTo(levelView.snp.bottom).offset(10)
        }
        
        addSubview(skillLevelView)
        skillLevelView.snp.makeConstraints { (make) in
            make.left.equalTo(rankView.snp.right)
            make.right.equalToSuperview()
            make.width.top.equalTo(rankView)
        }
        
//        addSubview(stackView)
//        stackView.snp.makeConstraints { (make) in
//            make.left.equalToSuperview()
//            make.right.lessThanOrEqualToSuperview()
//            make.top.greaterThanOrEqualTo(skillLevelView.snp.bottom).offset(5)
//            make.top.greaterThanOrEqualTo(rarityView.snp.bottom).offset(5)
//            make.height.equalTo(self.snp.width).dividedBy(6).offset(-50 / 6)
//            make.bottom.equalToSuperview()
//        }
//        stackView.axis = .horizontal
//        stackView.spacing = 10
//        stackView.distribution = .fillEqually
        
        icon.setContentCompressionResistancePriority(.required, for: .horizontal)
        icon.setContentCompressionResistancePriority(.required, for: .vertical)
        icon.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for chara: Chara) {
        let card = Card.findByID(Int(chara.id))
        
        if let iconID = card?.iconID {
            icon.unitID = iconID
        }
        
        rarityView.setup(stars: Int(chara.rarity))
        
        levelView.configure(for: NSLocalizedString("Level", comment: ""), content: String(chara.level))
        
        bondRankView.configure(for: NSLocalizedString("Bond Rank", comment: ""), content: String(chara.bondRank))
        
        rankView.configure(for: NSLocalizedString("Rank", comment: ""), content: String(chara.rank))
        
        skillLevelView.configure(for: NSLocalizedString("SLv.", comment: ""), content: String(chara.skillLevel))
        
//        icons.forEach {
//            $0.removeFromSuperview()
//        }
//        icons.removeAll()
//        
//        if let promotions = card?.promotions, promotions.indices ~= Int(chara.rank - 1) {
//            zip(chara.slots, promotions[Int(chara.rank - 1)].equipSlots).forEach {
//                let icon = SelectableIconImageView()
//                icon.equipmentID = $1
//                icon.isSelected = $0
//                stackView.addArrangedSubview(icon)
//                icons.append(icon)
//            }
//        }
        
    }
    
}

extension Chara {
    
    var slots: [Bool] {
        return [slot1, slot2, slot3, slot4, slot5, slot6]
    }
}
