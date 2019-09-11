//
//  SlotsCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/6/29.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Eureka

class SlotsCell: Cell<[Bool]>, CellType {

//    let titleLabel = UILabel()
    
    var icons = [SelectableIconImageView]()
    
    let stackView = UIStackView()
    
    override func setup() {
        super.setup()
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.right.lessThanOrEqualTo(readableContentGuide)
            make.top.equalTo(10)
            make.width.lessThanOrEqualTo(64 * 6 + 50)
            make.width.equalTo(stackView.snp.height).multipliedBy(6).offset(50)
            make.height.lessThanOrEqualTo(64)
        }
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually

        selectionStyle = .none
        
    }
    
    func configure(for promotion: Card.Promotion, slots: [Bool]) {
//        titleLabel.text = NSLocalizedString("Rank", comment: "") + " \(promotion.promotionLevel)"
        icons.forEach {
            $0.removeFromSuperview()
        }
        icons.removeAll()
        zip(slots, promotion.equipSlots).forEach {
            let icon = SelectableIconImageView()
            if $1 == 999999 {
                icon.isUserInteractionEnabled = false
                icon.equipmentID = $1
                icon.isSelected = true
            } else {
                icon.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
                icon.equipmentID = $1
                icon.isSelected = $0
                icon.addGestureRecognizer(tapGesture)
            }
            stackView.addArrangedSubview(icon)
            icons.append(icon)
        }
        
        stackView.layoutIfNeeded()
        row.value = icons.map { $0.isSelected && $0.equipmentID != 999999 }
        
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        stackView.layoutIfNeeded()
        var size = stackView.frame.size
        size.height += 20
        return size
    }
    
    @objc private func handleTapGestureRecognizer(_ tap: UITapGestureRecognizer) {
        if let imageView = tap.view as? SelectableIconImageView {
            imageView.isSelected = !imageView.isSelected
            if let index = icons.firstIndex(of: imageView) {
                row.value?[index] = imageView.isSelected
            }
        }
    }
    
    public override func update() {
        super.update()
        icons.enumerated().forEach {
            if let isSelected = row.value?[$0.offset], $0.element.equipmentID != 999999  {
                $0.element.isSelected = isSelected
            }
        }
        detailTextLabel?.text = ""
    }
}

final class SlotsRow: Row<SlotsCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}
