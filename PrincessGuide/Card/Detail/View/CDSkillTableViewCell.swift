//
//  CDSkillTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/20.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class CDSkillTableViewCell: UITableViewCell, CardDetailConfigurable {
    
    let skillIcon = IconImageView()
    
    let nameLabel = UILabel()
    
    let categoryLabel = UILabel()
    
    lazy var subtitleLabel = self.createSubTitleLabel(title: NSLocalizedString("Cast Time", comment: ""))
    
    let castTimeLabel = UILabel()
    
    let descLabel = UILabel()
    
    lazy var subtitleLabel2 = self.createSubTitleLabel(title: NSLocalizedString("Skill Detail", comment: ""))
    
    let actionLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectedBackgroundView = UIView()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { (themeable, theme) in
            themeable.nameLabel.textColor = theme.color.title
            themeable.categoryLabel.textColor = theme.color.caption
            themeable.castTimeLabel.textColor = theme.color.body
            themeable.descLabel.textColor = theme.color.body
            themeable.subtitleLabel.textColor = theme.color.title
            themeable.subtitleLabel2.textColor = theme.color.title
            themeable.actionLabel.textColor = theme.color.body
            themeable.selectedBackgroundView?.backgroundColor = theme.color.tableViewCell.selectedBackground
            themeable.backgroundColor = theme.color.tableViewCell.background
        }
        
        contentView.addSubview(skillIcon)
        skillIcon.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.height.width.equalTo(64)
            make.top.equalTo(10)
        }
        
        categoryLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 14)
        contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(skillIcon.snp.bottom)
            make.centerX.equalTo(skillIcon)
        }
        
        nameLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(skillIcon.snp.right).offset(10)
            make.top.equalTo(10)
        }
        
        descLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
        descLabel.numberOfLines = 0
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.right.equalTo(readableContentGuide)
        }
        descLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.greaterThanOrEqualTo(descLabel.snp.bottom).offset(5)
            make.top.greaterThanOrEqualTo(categoryLabel.snp.bottom).offset(5)
        }
        
        castTimeLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
        contentView.addSubview(castTimeLabel)
        castTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(subtitleLabel.snp.bottom)
        }
        
        contentView.addSubview(subtitleLabel2)
        subtitleLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(castTimeLabel.snp.bottom).offset(5)
        }
        
        contentView.addSubview(actionLabel)
        actionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.right.equalTo(readableContentGuide)
            make.top.equalTo(subtitleLabel2.snp.bottom)
            make.bottom.equalTo(-10)
        }
        actionLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
        actionLabel.numberOfLines = 0
        actionLabel.setContentCompressionResistancePriority(.required, for: .vertical)

    }
    
    private func createSubTitleLabel(title: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 14)
        label.text = title
        return label
    }
    
    func configure(for skill: Skill, category: SkillCategory, property: Property, index: Int? = nil) {
        nameLabel.text = skill.base.name
        if let index = index {
            categoryLabel.text = "\(category.description) \(index)"
        } else {
            categoryLabel.text = "\(category.description)"
        }
        castTimeLabel.text = "\(skill.base.skillCastTime)s"
        descLabel.text = skill.base.description
        skillIcon.skillIconID = skill.base.iconType
        actionLabel.text = skill.actions.map {
            let parameter = $0.parameter
            return "-\(parameter.id % 10)- \(parameter.localizedDetail(of: CDSettingsViewController.Setting.default.skillLevel, property: property))"
            }.joined(separator: "\n")
    }
    
    func configure(for item: CardDetailItem) {
        guard case .skill(let skill, let category, let property, let index) = item else { return }
        configure(for: skill, category: category, property: property, index: index)
    }
    
//    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
//        setNeedsLayout()
//        setNeedsUpdateConstraints()
//        updateConstraints()
//        layoutIfNeeded()
//        return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
//    }
//
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
