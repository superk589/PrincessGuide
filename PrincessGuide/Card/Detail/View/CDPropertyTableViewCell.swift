//
//  CDPropertyTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

typealias CDPropertyTableViewCell = CDProfileTableViewCell

extension CDPropertyTableViewCell {
    
    func configure(for items: [Property.Item]) {
        itemViews.forEach {
            $0.removeFromSuperview()
        }
        itemViews.removeAll()
        
        for item in items {
            let itemView = ProfileItemView()
            itemView.configure(for: item)
            itemViews.append(itemView)
            stackView.addArrangedSubview(itemView)
        }
    }
    
}
