//
//  CraftPropertyTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

typealias CraftPropertyTableViewCell = CDProfileTableViewCell

extension CDProfileTableViewCell: CraftDetailConfigurable {
    
    func configure(for item: CraftDetailItem) {
        guard case .properties(let properties) = item else {
            fatalError()
        }
        configure(for: properties)
    }
}
