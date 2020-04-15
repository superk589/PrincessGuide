//
//  AttackSealAction.swift
//  PrincessGuide
//
//  Created by zzk on 9/16/19.
//  Copyright © 2019 zzk. All rights reserved.
//

import Foundation

class AttackSealAction: ActionParameter {
    
    enum Condition: Int {
        case unknown = -1
        case damage = 1
        case target
        case hit
        case critical
    }
    
    enum Target: Int {
        case unknown = -1
        case target
        case owner
    }
    
    var condition: Condition {
        return Condition(rawValue: actionDetail1) ?? .unknown
    }
    
    var target: Target {
        return Target(rawValue: actionDetail3) ?? .unknown
    }
    
    var durationValues: [ActionValue] {
         return [
             ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: nil, startIndex: 3),
         ]
     }

    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch (condition, target) {
        case (.hit, _):
            let format = NSLocalizedString("Make %@ when get one hit by the caster, gain one mark stack(max %@, ID: %@) for [%@]s.", comment: "")
            return String(
                format: format,
                targetParameter.buildTargetClause(),
                actionValue1.roundedString(roundingRule: .down),
                actionValue2.roundedString(roundingRule: .down),
                buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
            )
        case (.damage, .owner):
            let format = NSLocalizedString("Make %@ when deal damage, gain one mark stack(max %@, ID: %@) for [%@]s.", comment: "")
            return String(
                format: format,
                targetParameter.buildTargetClause(),
                actionValue1.roundedString(roundingRule: .down),
                actionValue2.roundedString(roundingRule: .down),
                buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
            )
        case (.critical, .owner):
            let format = NSLocalizedString("Make %@ when deal critical damage, gain one mark stack(max %@, ID: %@) for [%@]s.", comment: "")
            return String(
                format: format,
                targetParameter.buildTargetClause(),
                actionValue1.roundedString(roundingRule: .down),
                actionValue2.roundedString(roundingRule: .down),
                buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
            )
        default:
            return super.localizedDetail(of: level, property: property, style: style)
        }
    }
}
