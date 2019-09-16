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
    }
    
    var condition: Condition {
        return Condition(rawValue: actionDetail1) ?? .unknown
    }
    
    var durationValues: [ActionValue] {
         return [
             ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: nil, startIndex: 3),
         ]
     }

    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        switch condition {
        case .hit:
            let format = NSLocalizedString("Make %@ when get one hit by the caster, gain one mark stack(max %@, ID: %@) for [%@]s.", comment: "")
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
