//
//  CraftTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/3.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class CraftTableViewCell: UITableViewCell, CraftDetailConfigurable, UniqueCraftConfigurable {
    
    let icon = IconImageView()
    
    let nameLabel = UILabel()
    
    let consumeNumberLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.nameLabel.textColor = theme.color.title
            themeable.consumeNumberLabel.textColor = theme.color.body
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
        }
        
        contentView.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
        
        contentView.addSubview(consumeNumberLabel)
        consumeNumberLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        consumeNumberLabel.snp.makeConstraints { (make) in
            make.right.equalTo(readableContentGuide)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(icon.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualTo(consumeNumberLabel).offset(-5)
        }
        nameLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        
    }
    
    func configure(name: String?, number: Int, itemURL: URL) {
        nameLabel.text = name
        consumeNumberLabel.text = String(number)
        icon.kf.setImage(with: itemURL, placeholder: #imageLiteral(resourceName: "icon_placeholder"))
    }
    
    func configure(for item: CraftDetailItem) {
        guard case .consume(let consume) = item else {
            fatalError()
        }
        configure(name: consume.equipment?.equipmentName, number: consume.consumeNum, itemURL: consume.itemURL)
    }
    
    func configure(for item: UniqueCraftItem) {
        guard case .consume(let consume) = item else {
            fatalError()
        }
        configure(name: nil, number: consume.consumeNum, itemURL: consume.itemURL)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
