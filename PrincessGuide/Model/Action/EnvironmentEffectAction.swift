//
//  EnvironmentEffectAction.swift
//  PrincessGuide
//
//  Created by zzk on 2024/7/2.
//  Copyright © 2024 zzk. All rights reserved.
//

import Foundation

class EnvironmentEffectAction: ActionParameter {
    
    var durationValues: [ActionValue] {
        return [
            ActionValue(initial: String(actionValue1), perLevel: String(actionValue2), key: nil, startIndex: 1),
        ]
    }
    
    override func localizedDetail(of level: Int, property: Property = .zero, style: CDSettingsViewController.Setting.ExpressionStyle = CDSettingsViewController.Setting.default.expressionStyle) -> String {
        let format = NSLocalizedString("Cast an environment effect of ID: %d for [%@]s.", comment: "")
        return String(
            format: format,
            actionDetail2,
            buildExpression(of: level, actionValues: durationValues, roundingRule: nil, style: style, property: property)
        )
    }
    
}
