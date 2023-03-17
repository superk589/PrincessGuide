//
//  UnableStateGuardAction.swift
//  PrincessGuide
//
//  Created by zzk on 2023/3/17.
//  Copyright © 2023 zzk. All rights reserved.
//

import Foundation

class UnableStateGuardAction: ActionParameter {
    
    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue3), perLevel: String(actionValue4), key: nil, startIndex: 3),
        ]
    }
    
    override var actionValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1)
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Make %@ immune to control effects up to [%@] times, lasts for [%@]s.", comment: "")
        return String(
            format: format,
            targetParameter.buildTargetClause(),
            buildExpression(of: level, roundingRule: nil, style: style, property: property),
            buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
        )
    }
    
}
