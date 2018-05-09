//
//  EDProfileTextTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

typealias EDProfileTextTableViewCell = CDProfileTextTableViewCell

extension EDProfileTextTableViewCell: EnemyDetailConfigurable {
    
    func configure(for item: EDTableViewController.Row.Model) {
        guard case .text(let title, let value) = item else {
            fatalError()
        }
        configure(for: title, content: value)
    }
}
