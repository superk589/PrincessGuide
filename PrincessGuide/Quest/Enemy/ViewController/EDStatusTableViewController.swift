//
//  EDStatusTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class EDStatusTableViewController: EDTableViewController {
    
    override func prepareRows() {
        rows.removeAll()
        rows += [
            Row(type: EDPropertyTableViewCell.self, data: .propertyItems([enemy.base.property.item(for: .atk),
                                                                          enemy.base.property.item(for: .magicStr)])),
            Row(type: EDPropertyTableViewCell.self, data: .propertyItems([enemy.base.property.item(for: .def),
                                                                          enemy.base.property.item(for: .magicDef)])),
            Row(type: EDPropertyTableViewCell.self, data: .propertyItems([enemy.base.property.item(for: .hp),
                                                                          enemy.base.property.item(for: .physicalCritical)])),
            Row(type: EDPropertyTableViewCell.self, data: .propertyItems([enemy.base.property.item(for: .dodge),
                                                                          enemy.base.property.item(for: .magicCritical)]))
        ]
        rows += [
            Row(type: CDProfileTextTableViewCell.self, data: .text(NSLocalizedString("Swing Time", comment: ""), "\(enemy.unit.normalAtkCastTime)s")),
            Row(type: CDProfileTextTableViewCell.self, data: .text(NSLocalizedString("Position", comment: ""), "\(enemy.unit.searchAreaWidth)"))
        ]
    }
    
}
