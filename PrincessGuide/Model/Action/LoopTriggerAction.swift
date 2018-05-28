//
//  LoopTriggerAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class LoopTriggerAction: ActionParameter {
    
    enum TriggerType: Int {
        case unknown = 0
        case dodge = 1
        case damaged
        case hp
        case dead
        case criticalDamaged
        case criticalDamagedWithSummon
    }
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(key: .initialValue, value: String(actionValue1)),
            ActionValue(key: .skillLevel, value: String(actionValue2))
        ]
    }
    
    override func localizedDetail(of level: Int) -> String {
        switch TriggerType(rawValue: actionDetail1) ?? .unknown {
        case .damaged:
            let format = NSLocalizedString("Condition: [%@]%% chance use %d when takes damage within %@s.", comment: "")
            return String(format: format, buildExpression(of: level), actionDetail2 % 10, actionValue4.description)
        default:
            return super.localizedDetail(of: level)
        }
    }
    
}
