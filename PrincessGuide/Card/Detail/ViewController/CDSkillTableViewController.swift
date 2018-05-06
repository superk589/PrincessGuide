//
//  CDTableViewController.swift
//  PrincessGuide
//
//  Created by zzk on 2018/4/11.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Gestalt

class CDSkillTableViewController: CDTableViewController {
    
    override func prepareRows(for card: Card) {
        
        rows.removeAll()
        
        card.patterns?.forEach {
            rows.append(Row(type: CDPatternTableViewCell.self, data: .pattern($0, card)))
        }
        
        if let unionBurst = card.unionBurst {
            rows.append(Row(type: CDSkillTableViewCell.self, data: .skill(unionBurst, .unionBurst)))
        }
        if let mainSkill1 = card.mainSkill1 {
            rows.append(Row(type: CDSkillTableViewCell.self, data: .skill(mainSkill1, .main)))
        }
        if let mainSkill2 = card.mainSkill2 {
            rows.append(Row(type: CDSkillTableViewCell.self, data: .skill(mainSkill2, .main)))
        }
        if let exSkill1 = card.exSkill1 {
            rows.append(Row(type: CDSkillTableViewCell.self, data: .skill(exSkill1, .ex)))
        }
        if let exSkillEvolution1 = card.exSkillEvolution1 {
            rows.append(Row(type: CDSkillTableViewCell.self, data: .skill(exSkillEvolution1, .exEvolution)))
        }
    }
    
}
