//
//  ClanBattleEnemyView.swift
//  PrincessGuide
//
//  Created by zzk on 12/28/20.
//  Copyright © 2020 zzk. All rights reserved.
//

import UIKit

class ClanBattleEnemyView: UIView {
    
    let enemyIcon = IconImageView()
    let defLabel = UILabel()
    let mdefLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(enemyIcon)
        enemyIcon.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.height.width.equalTo(64)
        }
        
        addSubview(defLabel)
        defLabel.snp.makeConstraints { (make) in
            make.top.equalTo(enemyIcon.snp.bottom)
            make.left.right.equalToSuperview()
        }
        defLabel.font = .systemFont(ofSize: 12)
        defLabel.textColor = Theme.dynamic.color.body
        defLabel.textAlignment = .center
        
        addSubview(mdefLabel)
        mdefLabel.snp.makeConstraints { (make) in
            make.top.equalTo(defLabel.snp.bottom)
            make.left.right.equalToSuperview()
        }
        mdefLabel.font = .systemFont(ofSize: 12)
        mdefLabel.textColor = Theme.dynamic.color.body
        mdefLabel.textAlignment = .center
        
    }
    
    func configure(for enemy: Enemy) {
        if enemy.unit.visualChangeFlag == 1 {
            enemyIcon.shadowUnitID = enemy.unit.prefabId
        } else {
            enemyIcon.unitID = enemy.unit.prefabId
        }
        if enemy.isBossPart {
            enemyIcon.layer.borderColor = UIColor.red.cgColor
            enemyIcon.layer.borderWidth = 2
            enemyIcon.layer.cornerRadius = 6
            enemyIcon.layer.masksToBounds = true
            enemyIcon.layer.borderColor = Theme.dynamic.color.highlightedText.cgColor
        } else {
            enemyIcon.layer.borderWidth = 0
        }
        
        if enemy.parts.count > 0 {
            defLabel.text = ""
            mdefLabel.text = ""
        } else {
            defLabel.setText(enemy.base.property.def.roundedString(roundingRule: nil), prependedBySymbolNameed: "shield.fill")
            mdefLabel.setText(enemy.base.property.magicDef.roundedString(roundingRule: nil), prependedBySymbolNameed: "sparkles")
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 64, height: 92)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UILabel {
    func setText(_ text: String, prependedBySymbolNameed symbolSystemName: String, font: UIFont? = nil) {
        if #available(iOS 13.0, *) {
            if let font = font { self.font = font }
            let symbolConfiguration = UIImage.SymbolConfiguration(font: self.font)
            let symbolImage = UIImage(systemName: symbolSystemName, withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate)
            let symbolTextAttachment = NSTextAttachment()
            symbolTextAttachment.image = symbolImage
            let attributedText = NSMutableAttributedString()
            attributedText.append(NSAttributedString(attachment: symbolTextAttachment))
            attributedText.append(NSAttributedString(string: " " + text))
            self.attributedText = attributedText
        } else {
            self.text = text // fallback
        }
    }
}
