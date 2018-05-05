//
//  CDPromotionTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class CDPromotionTableViewCell: UITableViewCell, CardDetailConfigurable {
    
    let titleLabel = UILabel()
    
    let promotionView = PromotionView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themable, theme) in
            themable.titleLabel.textColor = theme.color.title
            themable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themable.backgroundColor = theme.color.tableViewCell.background
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(10)
        }
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        
        contentView.addSubview(promotionView)
        promotionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(readableContentGuide)
            make.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for item: CardDetailItem) {
        guard case .promotion(let promotion) = item else { return }
        configure(for: promotion)
    }
    
    func configure(for promotion: Card.Promotion) {
        titleLabel.text = NSLocalizedString("Rank", comment: "") + " \(promotion.promotionLevel)"
        promotionView.configure(for: promotion)
    }
}
