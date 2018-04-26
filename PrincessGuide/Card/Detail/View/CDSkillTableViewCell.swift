//
//  CDSkillTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/20.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class CDSkillTableViewCell: UITableViewCell, CardDetailConfigurable {
    
    let skillIcon = SkillIconImageView()
    
    let nameLabel = UILabel()
    
    let categoryLabel = UILabel()
    
    let castTimeLabel = UILabel()
    
    let descLabel = UILabel()
    
    let stackView = UIStackView()
    
    var actionViews = [SkillActionView]()
        
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(skillIcon)
        skillIcon.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.height.width.equalTo(64)
            make.top.equalTo(10)
        }
        
        nameLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(skillIcon.snp.right).offset(10)
            make.top.equalTo(10)
        }
        
        categoryLabel.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 16)
        categoryLabel.textColor = .lightGray
        contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { (make) in
            make.right.equalTo(readableContentGuide)
            make.top.equalTo(nameLabel)
        }
        
        descLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
        descLabel.textColor = .darkGray
        descLabel.numberOfLines = 0
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.right.equalTo(readableContentGuide)
        }
        
        let subTitleLabel = createSubTitleLabel(title: NSLocalizedString("Cast Time", comment: ""))
        contentView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.greaterThanOrEqualTo(descLabel.snp.bottom).offset(5)
            make.top.greaterThanOrEqualTo(skillIcon.snp.bottom).offset(5)
        }
        
        castTimeLabel.font = UIFont.scaledFont(forTextStyle: .body, ofSize: 14)
        castTimeLabel.textColor = .darkGray
        contentView.addSubview(castTimeLabel)
        castTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(subTitleLabel.snp.bottom)
        }
        
        let subTitleLabel2 = createSubTitleLabel(title: NSLocalizedString("Skill Detail", comment: ""))
        contentView.addSubview(subTitleLabel2)
        subTitleLabel2.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(castTimeLabel.snp.bottom).offset(5)
        }
        
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .equalSpacing
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(readableContentGuide)
            make.top.equalTo(subTitleLabel2.snp.bottom)
            make.bottom.equalTo(-10)
            make.right.equalTo(readableContentGuide)
        }
        
    }
    
    private func createSubTitleLabel(title: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.scaledFont(forTextStyle: .title3, ofSize: 14)
        label.text = title
        return label
    }
    
    func configure(for skill: Skill, category: SkillCategory) {
        nameLabel.text = skill.base.name
        categoryLabel.text = category.description
        castTimeLabel.text = "\(skill.base.skillCastTime)s"
        descLabel.text = skill.base.description
        skillIcon.iconID = skill.base.iconType
        
        actionViews.forEach {
            $0.removeFromSuperview()
        }
        actionViews.removeAll()
        
        for action in skill.actions {
            let actionView = SkillActionView()
            actionView.configure(for: action)
            actionViews.append(actionView)
            stackView.addArrangedSubview(actionView)
        }
    }
    
    func configure(for item: CardDetailItem) {
        guard case .skill(let skill, let category) = item else { return }
        configure(for: skill, category: category)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
