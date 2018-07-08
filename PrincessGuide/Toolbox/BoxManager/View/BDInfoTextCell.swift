//
//  BDInfoTextCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/8.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

typealias BDInfoTextCell = CDProfileTextTableViewCell

extension BDInfoTextCell: BDInfoConfigurable {

    func configure(for model: BDInfoViewController.Row.Model) {
        guard case .text(let array) = model else {
            fatalError()
        }
        configure(for: array)
    }

}
