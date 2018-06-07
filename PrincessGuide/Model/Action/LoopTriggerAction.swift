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
            ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch TriggerType(rawValue: actionDetail1) ?? .unknown {
        case .damaged:
            let format = NSLocalizedString("Condition: [%@]%% chance use %d when takes damage within %@s.", comment: "")
            return String(format: format, buildExpression(of: level, style: style, property: property), actionDetail2 % 10, actionValue4.description)
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
    
}
