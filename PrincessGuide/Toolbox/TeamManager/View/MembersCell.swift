//
//  MembersCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/7/10.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Eureka

protocol MembersCellDelegate: class {
    func membersCell(_ membersCell: MembersCell, didSelect member: Member)
}

class MembersCell: Cell<[Member]>, CellType {
    
    var icons = [IconImageView]()
    
    let stackView = UIStackView()
    
    weak var delegate: MembersCellDelegate?
    
    override func setup() {
        super.setup()
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.right.lessThanOrEqualTo(readableContentGuide)
            make.top.equalTo(10)
            make.width.lessThanOrEqualTo(64 * 5 + 40)
            make.width.equalTo(stackView.snp.height).multipliedBy(5).offset(40)
            make.height.lessThanOrEqualTo(64)
        }
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        selectionStyle = .none
        
    }
    
    func configure(for members: [Member]) {

        icons.forEach {
            $0.removeFromSuperview()
        }
        icons.removeAll()
        
        let sortedMembers = members.sorted { ($0.card?.base.searchAreaWidth ?? .min) > ($1.card?.base.searchAreaWidth ?? .min) }
        
        sortedMembers.forEach {
            let icon = IconImageView()
            icon.isUserInteractionEnabled = true
            icon.configure(iconURL: $0.iconURL, placeholderStyle: .blank)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
            icon.addGestureRecognizer(tapGesture)
            stackView.addArrangedSubview(icon)
            icons.append(icon)
        }
        
        stackView.layoutIfNeeded()
        
        row.value = sortedMembers
        
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        stackView.layoutIfNeeded()
        var size = stackView.frame.size
        size.height += 20
        return size
    }
    
    @objc private func handleTapGestureRecognizer(_ tap: UITapGestureRecognizer) {
        if let view = tap.view as? IconImageView, let index = icons.firstIndex(of: view),
            let member = row.value?[index] {
            delegate?.membersCell(self, didSelect: member)
        }
    }
    
    public override func update() {
        super.update()
        detailTextLabel?.text = ""
    }
}

final class MembersRow: Row<MembersCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

