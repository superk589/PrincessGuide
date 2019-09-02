//
//  CDPromotionTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt
import SnapKit
import Reusable

protocol CDPromotionTableViewCellDelegate: class {
    func cdPromotionTableViewCell(_ cdPromotionTableViewCell: CDPromotionTableViewCell, didSelect index: Int)
}

class CDPromotionTableViewCell: UITableViewCell, Reusable {
    
    let titleLabel = UILabel()
    
    var icons = [IconImageView]()
    let stackView = UIStackView()
    
    weak var delegate: CDPromotionTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, imageURLs: [URL]) {
        titleLabel.text = title
        
        icons.forEach {
            $0.removeFromSuperview()
        }
        icons.removeAll()
        
        imageURLs.forEach {
            let icon = IconImageView()
            icon.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizer(_:)))
            icon.configure(iconURL: $0, placeholderStyle: .questionMark)
            icon.addGestureRecognizer(tapGesture)
            stackView.addArrangedSubview(icon)
            icons.append(icon)
        }
        
        if imageURLs.count < 6 {
            (imageURLs.count..<6).forEach { _ in
                let icon = IconImageView()
                stackView.addArrangedSubview(icon)
                icons.append(icon)
            }
        }
    }
    
    @objc private func handleTapGestureRecognizer(_ tap: UITapGestureRecognizer) {
        if let imageView = tap.view as? IconImageView, let index = icons.firstIndex(of: imageView) {
            delegate?.cdPromotionTableViewCell(self, didSelect: index)
        }
    }
}
