//
//  CDPatternTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/25.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class CDPatternTableViewCell: UITableViewCell, CardDetailConfigurable {
    
    let titleLabel = UILabel()
    
    let attackPatternView = AttackPatternView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectedBackgroundView = UIView()

        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.titleLabel.textColor = theme.color.title
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
        }
        
        titleLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(readableContentGuide)
        }
        titleLabel.text = NSLocalizedString("Attack Pattern", comment: "")
        
        contentView.addSubview(attackPatternView)
        attackPatternView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.right.left.equalTo(readableContentGuide)
            make.bottom.equalToSuperview()
        }
        
        selectionStyle = .none
    }
    
    func configure(for item: CardDetailItem) {
        guard case .pattern(let pattern, let card, let index) = item else { return }
        configure(for: pattern, atkType: card.base.atkType, skills: card.mainSkills, index: index)
    }
    
    func configure(for pattern: AttackPattern, atkType: Int, skills: [Skill], index: Int?) {
        if let index = index {
            titleLabel.text = "\(NSLocalizedString("Attack Pattern", comment: "")) \(index)"
        } else {
            titleLabel.text = NSLocalizedString("Attack Pattern", comment: "")
        }
        attackPatternView.configure(for: pattern, atkType: atkType, skills: skills)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CDPatternTableViewCell: MinionDetailConfigurable {
    func configure(for item: MinionDetailItem) {
        guard case .pattern(let pattern, let minion, let index) = item else { return }
        configure(for: pattern, atkType: minion.base.atkType, skills: minion.mainSkills, index: index)
    }
}
