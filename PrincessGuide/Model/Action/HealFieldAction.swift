//
//  HealFieldAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class HealFieldAction: ActionParameter {
    
    var healClass: ClassModifier {
        return ClassModifier(rawValue: actionDetail1) ?? .unknown
    }
    
    override var actionValues: [ActionValue] {
        switch healClass {
        case .magical:
            return [
                ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: .magicStr),
                ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil)
            ]
        case .physical:
            return [
                ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: .atk),
                ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil)
            ]
        default:
            return []
        }
    }
    
    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue5), perLevel: String(actionValue6), key: nil),
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Summon a healing field of radius %d at %@ position to heal all friendly targets [%@] HP per second for [%@]s.", comment: "")
        return String(format: format, Int(actionValue7), targetParameter.buildTargetClause(), buildExpression(of: level, style: style, property: property), buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property))
    }
}
