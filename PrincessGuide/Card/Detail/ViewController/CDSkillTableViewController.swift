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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleSettingsChange(_:)), name: .cardDetailSettingsDidChange, object: nil)
    }
    
    @objc private func handleSettingsChange(_ notification: Notification) {
        reloadAll()
    }
    
    override func prepareRows(for card: Card) {
        
        let property: Property
        let settings = CDSettingsViewController.Setting.default
        if CDSettingsViewController.Setting.default.expressionStyle == .valueOnly {
            property = card.property(unitLevel: settings.unitLevel, unitRank: settings.unitRank, bondRank: settings.bondRank, unitRarity: settings.unitRarity, addsEx: false)
        } else if CDSettingsViewController.Setting.default.expressionStyle == .valueInCombat {
            property = card.property(unitLevel: settings.unitLevel, unitRank: settings.unitRank, bondRank: settings.bondRank, unitRarity: settings.unitRarity, addsEx: true)
        } else {
            property = .zero
        }
        
        rows.removeAll()
        
        card.patterns?.forEach {
            rows.append(Row(type: CDPatternTableViewCell.self, data: .pattern($0, card)))
        }
        
        if let unionBurst = card.unionBurst {
            rows.append(Row(type: CDSkillTableViewCell.self, data: .skill(unionBurst, .unionBurst, property, nil)))
        }
        
        rows.append(contentsOf:
            card.mainSkills
                .enumerated()
                .map {
                    Row(type: CDSkillTableViewCell.self, data: .skill($0.element, .main, property, $0.offset + 1))
            }
        )
        
        rows.append(contentsOf:
            card.exSkills
                .enumerated()
                .map {
                    Row(type: CDSkillTableViewCell.self, data: .skill($0.element, .ex, property, $0.offset + 1))
            }
        )
        
        rows.append(contentsOf:
            card.exSkillEvolutions
                .enumerated()
                .map {
                    Row(type: CDSkillTableViewCell.self, data: .skill($0.element, .exEvolution, property, $0.offset + 1))
            }
        )
    }
    
}
