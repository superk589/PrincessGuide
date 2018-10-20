//
//  AttackFieldAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

class AttackFieldAction: ActionParameter {
    
    var damageClass: ClassModifier {
        return actionDetail1 % 2 == 0 ? .magical : .physical
    }
    
    var fieldType: FieldType {
        if actionDetail1 <= 2 {
            return .normal
        } else {
            return .repeat
        }
    }
    
    //    let repeatNumber = 2
    
    override var actionValues: [ActionValue] {
        switch damageClass {
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
        switch fieldType {
        case .normal:
            return super.localizedDetail(of: level, property: property, style: style)
        case .repeat:
            let format = NSLocalizedString("Summon an attack field of radius %d at %@ position to deal all enemy targets [%@] %@ damage per second for [%@]s.", comment: "")
            return String(
                format: format,
                Int(actionValue7),
                targetParameter.buildTargetClause(),
                buildExpression(of: level, style: style, property: property),
                damageClass.description,
                buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
            )
        }
    }
    
}
