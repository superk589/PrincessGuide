//
//  HealDownAction.swift
//  PrincessGuide
//
//  Created by zzk on 10/31/20.
//  Copyright © 2020 zzk. All rights reserved.
//

import Foundation

class HealDownAction: ActionParameter {
    
    var percentModifier: PercentModifier {
        return PercentModifier(Int(actionValue1))
    }
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1)
        ]
    }
    
    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: nil, startIndex: 3)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Multiple heal effects from %@ with [%@] for [%@]s.", comment: "")
        return String(
            format: format,
            targetParameter.buildTargetClause(),
            buildExpression(of: level, roundingRule: nil, style: style, property: property),
            buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
            )
    }
}
