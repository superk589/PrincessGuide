//
//  CraftTextTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

typealias CraftTextTableViewCell = CDProfileTextTableViewCell

extension CraftTextTableViewCell: CraftDetailConfigurable {
    
    func configure(for item: CraftDetailItem) {
        guard case .text(let title, let content) = item else {
            fatalError()
        }
        configure(for: title, content: content)
    }
}

