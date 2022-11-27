//
//  EnergyDamageReduceAction.swift
//  PrincessGuide
//
//  Created by zzk on 2022/11/27.
//  Copyright © 2022 zzk. All rights reserved.
//

import Foundation

class EnergyDamageReduceAction: ActionParameter {
    
    
    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue2), perLevel: String(actionValue3), key: nil, startIndex: 2),
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("When %@ affected by TP loss effect, multiple the effect value by [%@], lasts for [%@]s.", comment: "")
        return String(
            format: format,
            targetParameter.buildTargetClause(),
            actionValue1.roundedString(roundingRule: nil),
            buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
        )
    }
    
}
