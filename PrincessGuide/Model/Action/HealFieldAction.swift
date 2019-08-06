//
//  HealFieldAction.swift
//  PrincessGuide
//
//  Created by zzk on 2018/5/26.
//  Copyright © 2018 zzk. All rights reserved.
//

import Foundation

enum FieldType {
    case normal
    case `repeat`
}

class HealFieldAction: ActionParameter {
    
    var healClass: ClassModifier {
        return actionDetail1 % 2 == 0 ? .magical : .physical
    }
    
    var percentModifier: PercentModifier {
        return PercentModifier(actionDetail2)
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
        switch healClass {
        case .magical:
            return [
                ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: .magicStr, startIndex: 3),
                ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1)
            ]
        case .physical:
            return [
                ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: .atk, startIndex: 3),
                ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1)
            ]
        default:
            return []
        }
    }
    
    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue5), perLevel: String(actionValue6), key: nil, startIndex: 5),
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch fieldType {
        case .normal:
            return super.localizedDetail(of: level, property: property, style: style)
        case .repeat:
            if targetParameter.targetType == .absolute {
                let format = NSLocalizedString("Summon a healing field of radius %d to heal %@ [%@]%@ HP per second for [%@]s.", comment: "")
                return String(
                    format: format,
                    Int(actionValue7),
                    targetParameter.buildTargetClause(),
                    buildExpression(of: level, style: style, property: property),
                    percentModifier.description,
                    buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
                )
            } else {
                let format = NSLocalizedString("Summon a healing field of radius %d at position of %@ to heal [%@]%@ HP per second for [%@]s.", comment: "")
                return String(
                    format: format,
                    Int(actionValue7),
                    targetParameter.buildTargetClause(),
                    buildExpression(of: level, style: style, property: property),
                    percentModifier.description,
                    buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
                )
            }
        }
    }
}
