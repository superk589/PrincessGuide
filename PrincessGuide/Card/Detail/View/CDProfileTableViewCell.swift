//
//  CDProfileTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/7.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class CDProfileTableViewCell: UITableViewCell, CardDetailConfigurable {

    let stackView = UIStackView()
    
    var itemViews = [ProfileItemView]()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            themable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themable.backgroundColor = theme.color.tableViewCell.background
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for items: [Card.Profile.Item]) {
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
    
    func configure(for item: CardDetailItem) {
        guard case .profile(let items) = item else {
            fatalError()
        }
        configure(for: items)
    }

}
