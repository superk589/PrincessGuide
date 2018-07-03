//
//  SlotCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/6/29.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Eureka
import Gestalt

class SlotCell: Cell<[Bool]>, CellType {

    let titleLabel = UILabel()
    
    var icons = [SelectableIconImageView]()
    
    let stackView = UIStackView()
    
    override func setup() {
        super.setup()
        
        selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.titleLabel.textColor = theme.color.title
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
        }
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.right.lessThanOrEqualTo(readableContentGuide)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
            make.width.lessThanOrEqualTo(64 * 6 + 50)
            make.width.equalTo(stackView.snp.height).multipliedBy(6).offset(50)
        }
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        selectionStyle = .none
        
    }
    
    func configure(for promotion: Card.Promotion) {
        titleLabel.text = NSLocalizedString("Rank", comment: "") + " \(promotion.promotionLevel)"
        icons.forEach {
            $0.removeFromSuperview()
        }
        promotion.equipSlots.forEach {
            let icon = SelectableIconImageView()
            icon.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
            icon.equipmentID = $0
            icon.isSelected = true
            icon.addGestureRecognizer(tapGesture)
            stackView.addArrangedSubview(icon)
            icons.append(icon)
        }
        
        row.value = icons.map { $0.isSelected }
    }
    
    @objc private func handleTapGestureRecognizer(_ tap: UITapGestureRecognizer) {
        if let imageView = tap.view as? SelectableIconImageView, let id = imageView.equipmentID, id != 999999 {
            imageView.isSelected = !imageView.isSelected
            if let index = icons.firstIndex(of: imageView) {
                row.value?[index] = imageView.isSelected
            }
        }
    }
    
    public override func update() {
        super.update()
        icons.enumerated().forEach {
            if let isSelected = row.value?[$0.offset] {
                $0.element.isSelected = isSelected
            }
        }
        detailTextLabel?.text = ""
    }
}

final class SlotRow: Row<SlotCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}
