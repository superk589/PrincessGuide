//
//  BattleTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/13.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class BattleTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for battle: Battle) {
        
    }

}
