//
//  CDProfileTextTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class CDProfileTextTableViewCell: UITableViewCell, CardDetailConfigurable {
    
    let stackView = UIStackView()
    
    var itemViews = [CDTextItemView]()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
        }
        
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.right.equalTo(readableContentGuide)
        }
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for item: CardDetailItem) {
        if case .text(let title, let content, let comparisonMode) = item {
            configure(for: [(title, content, comparisonMode)])
        } else if case .textArray(let elements) = item {
            configure(for: elements)
        }
    }
    
    func configure(for title: String, content: String, comparisonMode: Bool = false) {
        itemViews.forEach {
            $0.removeFromSuperview()
        }
        itemViews.removeAll()
        let itemView = CDTextItemView()
        itemView.configure(for: title, content: content, comparisonMode: comparisonMode)
        itemViews.append(itemView)
        stackView.addArrangedSubview(itemView)
    }
    
    func configure(for elements: [(String, String, Bool)]) {
        itemViews.forEach {
            $0.removeFromSuperview()
        }
        itemViews.removeAll()
        for element in elements {
            let itemView = CDTextItemView()
            itemView.configure(for: element.0, content: element.1, comparisonMode: element.2)
            itemViews.append(itemView)
            stackView.addArrangedSubview(itemView)
        }
    }
    
}

extension CDProfileTextTableViewCell: MinionDetailConfigurable {
    func configure(for item: MinionDetailItem) {
        if case .text(let title, let content) = item {
            configure(for: [(title, content, false)])
        } else if case .textArray(let elements) = item {
            configure(for: elements.map { ($0.0, $0.1, false) })
        }
    }
}
