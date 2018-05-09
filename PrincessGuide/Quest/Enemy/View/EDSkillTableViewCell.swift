//
//  EDSkillTableViewCell.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

typealias EDSkillTableViewCell = CDSkillTableViewCell

extension EDSkillTableViewCell: EnemyDetailConfigurable {
    
    func configure(for skill: Skill, category: SkillCategory, level: Int) {
        nameLabel.text = skill.base.name
        categoryLabel.text = category.description
        castTimeLabel.text = "\(skill.base.skillCastTime)s"
        descLabel.text = skill.base.description
        skillIcon.skillIconID = skill.base.iconType
        actionLabel.text = skill.actions.map { "- \($0.detail(of: level))" }.joined(separator: "\n")
    }
    
    func configure(for item: EnemyDetailItem) {
        guard case .skill(let skill, let category, let level) = item else {
            fatalError()
        }
        configure(for: skill, category: category, level: level)
    }
}
