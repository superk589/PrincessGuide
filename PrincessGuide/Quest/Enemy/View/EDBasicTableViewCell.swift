//
//  EDBasicTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/12.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

typealias EDBasicTableViewCell = CDBasicTableViewCell

extension EDBasicTableViewCell: EnemyDetailConfigurable {
    
    func configure(for enemyUnit: Enemy.Unit) {
        nameLabel.text = enemyUnit.unitName
        commentLabel.text = enemyUnit.comment.replacingOccurrences(of: "\\n", with: "\n")
        if enemyUnit.visualChangeFlag == 1 {
            cardIcon.shadowUnitID = enemyUnit.prefabId
        } else {
            cardIcon.unitID = enemyUnit.unitId
        }
    }
    
    func configure(for item: EnemyDetailItem) {
        guard case .unit(let unit) = item else {
            fatalError()
        }
        configure(for: unit)
    }
}
