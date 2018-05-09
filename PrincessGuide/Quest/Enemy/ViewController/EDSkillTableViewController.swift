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
            rows.append(Row(type: EDSkillTableViewCell.self, data: .skill(unionBurst, .unionBurst, enemy.base.unionBurstLevel)))
        }
        if let mainSkill1 = enemy.mainSkill1 {
            rows.append(Row(type: EDSkillTableViewCell.self, data: .skill(mainSkill1, .main, enemy.base.mainSkillLv1)))
        }
        if let mainSkill2 = enemy.mainSkill2 {
            rows.append(Row(type: EDSkillTableViewCell.self, data: .skill(mainSkill2, .main, enemy.base.mainSkillLv2)))
        }
        if let mainSkill3 = enemy.mainSkill3 {
            rows.append(Row(type: EDSkillTableViewCell.self, data: .skill(mainSkill3, .main, enemy.base.mainSkillLv3)))
        }
        if let exSkill1 = enemy.exSkill1 {
            rows.append(Row(type: EDSkillTableViewCell.self, data: .skill(exSkill1, .ex, enemy.base.exSkillLv1)))
        }
    }

}
