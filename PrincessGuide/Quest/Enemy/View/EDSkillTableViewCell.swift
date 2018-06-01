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
    
    func configure(for skill: Skill, category: SkillCategory, level: Int, property: Property, index: Int? = nil) {
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
            return "-\(parameter.id % 10)- \(parameter.localizedDetail(of: level, property: property, style: .valueInCombat))"
            }.joined(separator: "\n")
    }
    
    func configure(for item: EnemyDetailItem) {
        guard case .skill(let skill, let category, let level, let property, let index) = item else {
            fatalError()
        }
        configure(for: skill, category: category, level: level, property: property, index: index)
    }
}
