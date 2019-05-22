//
//  EnemyView.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/9.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class EnemyView: UIView {
    
    let enemyIcon = IconImageView()
    
    let borderLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.lineCap = .round
        layer.strokeColor = UIColor.red.cgColor
        layer.lineDashPattern = [2, 4]
        layer.fillColor = nil
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(enemyIcon)
        enemyIcon.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.height.width.equalTo(64)
        }
        layer.addSublayer(borderLayer)
    }
    
    func configure(for enemy: Enemy) {
        if enemy.unit.visualChangeFlag == 1 {
            enemyIcon.shadowUnitID = enemy.unit.prefabId
        } else {
            enemyIcon.unitID = enemy.unit.prefabId
        }
        borderLayer.isHidden = !enemy.isBossPart
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderLayer.frame = bounds
        borderLayer.path = UIBezierPath(rect: bounds.inset(by: UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0))).cgPath
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 64, height: 64)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
