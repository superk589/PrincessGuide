//
//  EDPropertyTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

protocol EnemyDetailConfigurable {
    func configure(for item: EDTableViewController.Row.Model)
}

typealias EDPropertyTableViewCell = CDPropertyTableViewCell

extension EDPropertyTableViewCell: EnemyDetailConfigurable {

    func configure(for item: EDTableViewController.Row.Model) {
        guard case .propertyItems(let items, let unitLevel, let targetLevel) = item else {
            fatalError()
        }
        configure(for: items, unitLevel: unitLevel, targetLevel: targetLevel, comparisonMode: false)
    }

}
