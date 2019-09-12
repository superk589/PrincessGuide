//
//  BoxCoverCell.swift
//  PrincessGuide
//
//  Created by zzk on 9/12/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import UIKit
import Eureka

class BoxCoverCell: Cell<URL>, CellType {
    
    let titleLabel = UILabel()
    
    let icon = IconImageView()
    
    override func setup() {
        super.setup()
        
        titleLabel.textColor = Theme.dynamic.color.title
        titleLabel.text = NSLocalizedString("Box Cover", comment: "")
        contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.centerY.equalToSuperview()
        }
        
        accessoryType = .disclosureIndicator
        
        selectionStyle = .none
    }
    
    public override func update() {
        super.update()
        icon.configure(iconURL: row.value, placeholderStyle: .blank)
        detailTextLabel?.text = ""
    }
}

final class BoxCoverRow: Row<BoxCoverCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}
