//
//  EDSkillTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit

class EDSkillTableViewController: EDTableViewController {

    override func prepareRows() {
        
        rows.removeAll()
        
        enemy.patterns?.forEach {
            rows.append(Row(type: EDPatternTableViewCell.self, data: .pattern($0, enemy)))
        }
        
        if let unionBurst = enemy.unionBurst {
            rows.append(Row(type: EDSkillTableViewCell.self, data: .skill(unionBurst, .unionBurst, enemy.base.unionBurstLevel, nil)))
        }
        if let mainSkill1 = enemy.mainSkill1 {
            rows.append(Row(type: EDSkillTableViewCell.self, data: .skill(mainSkill1, .main, enemy.base.mainSkillLv1, 1)))
        }
        if let mainSkill2 = enemy.mainSkill2 {
            rows.append(Row(type: EDSkillTableViewCell.self, data: .skill(mainSkill2, .main, enemy.base.mainSkillLv2, 2)))
        }
        if let mainSkill3 = enemy.mainSkill3 {
            rows.append(Row(type: EDSkillTableViewCell.self, data: .skill(mainSkill3, .main, enemy.base.mainSkillLv3, 3)))
        }
        if let mainSkill4 = enemy.mainSkill4 {
            rows.append(Row(type: EDSkillTableViewCell.self, data: .skill(mainSkill4, .main, enemy.base.mainSkillLv4, 4)))
        }
        if let mainSkill5 = enemy.mainSkill5 {
            rows.append(Row(type: EDSkillTableViewCell.self, data: .skill(mainSkill5, .main, enemy.base.mainSkillLv5, 5)))
        }
        if let mainSkill6 = enemy.mainSkill6 {
            rows.append(Row(type: EDSkillTableViewCell.self, data: .skill(mainSkill6, .main, enemy.base.mainSkillLv6, 6)))
        }
        if let mainSkill7 = enemy.mainSkill7 {
            rows.append(Row(type: EDSkillTableViewCell.self, data: .skill(mainSkill7, .main, enemy.base.mainSkillLv7, 7)))
        }
        if let mainSkill8 = enemy.mainSkill8 {
            rows.append(Row(type: EDSkillTableViewCell.self, data: .skill(mainSkill8, .main, enemy.base.mainSkillLv8, 8)))
        }
        if let mainSkill9 = enemy.mainSkill9 {
            rows.append(Row(type: EDSkillTableViewCell.self, data: .skill(mainSkill9, .main, enemy.base.mainSkillLv9, 9)))
        }
        if let mainSkill10 = enemy.mainSkill10 {
            rows.append(Row(type: EDSkillTableViewCell.self, data: .skill(mainSkill10, .main, enemy.base.mainSkillLv10, 10)))
        }
        if let exSkill1 = enemy.exSkill1 {
            rows.append(Row(type: EDSkillTableViewCell.self, data: .skill(exSkill1, .ex, enemy.base.exSkillLv1, nil)))
        }
    }

}
